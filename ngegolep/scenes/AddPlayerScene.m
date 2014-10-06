//
//  AddPlayerScene.m
//  ngegolep
//
//  Created by Rukmono Erwan on 9/25/14.
//  Copyright (c) 2014 palawamaya. All rights reserved.
//

#import "AddPlayerScene.h"
#import "DBManager.h"

@interface AddPlayerScene ()

@property (nonatomic, strong) DBManager *dbManager;

-(void)loadInfoToEdit;

@end

@implementation AddPlayerScene

- (void)viewDidLoad {
    
    // make self the delegate of textfields
    self.txtFirstname.delegate = self;
    self.txtLastname.delegate = self;
    
    // initialize dbManager object
    self.dbManager == [[DBManager alloc] initWithDatabaseFilename:@"ngegolep.sqlite"];
    
    // check id should load spesific record for editing
    if (self.recordIDToEdit != -1) {
        // load the record with spesific ID from database
        [self loadInfoToEdit];
    }
    
    [super viewDidLoad];
    // set navigation bar tint color
    self.navigationController.navigationBar.tintColor = self.navigationItem.rightBarButtonItem.tintColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)saveInfo:(id)sender {
    // prepare the query string
    //NSString *query = [NSString stringWithFormat:@"insert into players values(null, '%@', '%@', %d)", self.txtFirstname.text, self.txtLastname.text];
    
    NSString *query;
    if (self.recordIDToEdit == -1) {
        query = [NSString stringWithFormat:@"insert into players values(null, '%@', '%@', %d)", self.txtFirstname.text, self.txtLastname.text];
    }
    else {
        query = [NSString stringWithFormat:@"update players set firstname='%@', lastname='%@'", self.txtFirstname.text, self.txtLastname.text, self.recordIDToEdit];
    }
    
    // execute the query
    [self.dbManager executeQuery:query];
    
    // if the query was successfully execute then pop the view controller
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        // inform the delegate that the editing was finished
        [self.delegate editingInfoWasFinished];
        
        // pop the view controller
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        NSLog(@"Could not execute the query");
    }
}

-(void)loadInfoToEdit {
    // create the query
    NSString *query = [NSString stringWithFormat:@"select * from players where firstname=%d", self.recordIDToEdit];
    
    // load the relevant data
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // set the loaded data to the textfields
    self.txtFirstname.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"firstname"]];
    self.txtLastname.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"lastname"]];
}

@end