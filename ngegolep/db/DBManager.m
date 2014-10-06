//
//  DBManager.m
//  ngegolep
//
//  Created by Rukmono Erwan on 9/25/14.
//  Copyright (c) 2014 palawamaya. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>

// sqlite file properties
@interface DBManager()
@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;

// sqlite process properties
@property (nonatomic, strong) NSMutableArray *arrResults;

// copy database file into the documents directory method declaration
-(void) copyDatabaseIntoDocumentsDirectory;

// sqlite process method declaration
-(void) runQuery:(const char *) query isQueryExecutable:(BOOL) queryExecutable;

@end

@implementation DBManager

// sqlite standard definition of all init methods
-(instancetype) initWithDatabaseFilename:(NSString *)dbFilename {
    self = [super init];
    if (self) {
        // set the documents directory path to the documentsDirectory property
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        
        // keep the database file
        self.databaseFilename = dbFilename;
        
        // copy database file into the documents directory if necessary
        [self copyDatabaseIntoDocumentsDirectory];
    }
    return self;
}

// copy database file into documents directory method
-(void) copyDatabaseIntoDocumentsDirectory {
    //check if database file exists in the documents directory
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        // database file doesn't exist in the documents directory, so copy it from main bundle now
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        // check if any error occurred during copying and display it
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

// sqlite process methods
-(void) runQuery:(const char *) query isQueryExecutable:(BOOL) queryExecutable {
    // create sql object
    sqlite3 *sqlite3Database;
    
    // set database file path
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    // initialize the results array
    if (self.arrResults != nil) {
        [self.arrResults removeAllObjects];
        self.arrResults = nil;
    }
    
    // initialize the column names array
    if (self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];
    
    // open database
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if (openDatabaseResult == SQLITE_OK) {
        // declare a sqlite3_stmt object in which will be stored the query after having been compiled into a SQLite statement
        sqlite3_stmt *compiledStatement;
        
        // load all data from database to memory
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        if (prepareStatementResult == SQLITE_OK) {
            // check if the query is non-executable
            if (!queryExecutable) {
                // in this case data must be loaded from database
                // declare an array to keep the data for each fetched row
                NSMutableArray *arrDataRow;
                
                // loop through the results and add them to the results arraw row by row
                while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    // initialize the mutable array that will contain the data of fetched row
                    arrDataRow = [[NSMutableArray alloc] init];
                    
                    // get total number of columns
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
                    // go through all columns and fetch each column data
                    for (int i=0; i<totalColumns; i++) {
                        // convert the column data to text (characters)
                        char *dbDataAsChars = (char *) sqlite3_column_text(compiledStatement, i);
                        
                        // if there are contents in the current column (field) then add to the current row array
                        if (dbDataAsChars != NULL) {
                            [arrDataRow addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    
                    // store each fetched data row in the results array, but first check if there is actually data
                    if (arrDataRow.count > 0) {
                        [self.arrResults addObject:arrDataRow];
                    }
                }
            }
            else {
                // this is for executable query (insert, update, ...)
                
                // execute query
                BOOL executeQueryResults = sqlite3_step(compiledStatement);
                if (executeQueryResults == SQLITE_DONE) {
                    // keep the affected rows
                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    
                    // keep the last inserted row ID
                    self.lastinsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                }
                else {
                    // if could not execute the query show the error message on the debugger
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
                }
            }
        }
        else {
            // in the database cannot be opened be opened the show the error message on the debugger
            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
        }
        
        // release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
    }
    
    // close the database
    sqlite3_close(sqlite3Database);
}

-(NSArray *) loadDataFromDB:(NSString *)query {
    // run query and indicate that is not executable
    // the query string is converted to a char* object
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    
    // return the loaded results
    return (NSArray *) self.arrResults;
}

-(void) executeQuery:(NSString *)query {
    // run the query and indicate that is executable
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}

@end