//
//  DBManager.h
//  ngegolep
//
//  Created by Rukmono Erwan on 9/25/14.
//  Copyright (c) 2014 palawamaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject

// sqlite 
@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastinsertedRowID;

// sqlite declaration
-(instancetype) initWithDatabaseFilename:(NSString *)dbFilename;

// sqlite queries declaration
-(NSArray *) loadDataFromDB:(NSString *) query;
-(void) executeQuery:(NSString *) query;

@end