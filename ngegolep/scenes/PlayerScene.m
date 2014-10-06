//
//  PlayerScene.m
//  ngegolep
//
//  Created by Rukmono Erwan on 9/25/14.
//  Copyright (c) 2014 palawamaya. All rights reserved.
//

#import "PlayerScene.h"
#import "DBManager.h"

@interface PlayerScene ()

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrPlayer;

@property (nonatomic) int recordIDToEdit;

-(void)loadData;

@end

@implementation PlayerScene

- (void)viewDidLoad {
    // initialize the dbManager property
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"ngegolep.sqlite"];
    
    // load the data
    [self loadData];
    
    [super viewDidLoad];
    // make self the delegate and datasource of the table view
    self.tblPlayer.delegate = self;
    self.tblPlayer.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AddPlayerScene *playerSceneViewController = [segue destinationViewController];
    playerSceneViewController.delegate = self;
    playerSceneViewController.recordIDToEdit = self.recordIDToEdit;
}

-(IBAction)addNewRecord:(id)sender {
    //[self performSegueWithIdentifier:@"idSegueAddPlayer" sender:self];
    
    // before performing the segue, set the -1 value to recordIDToEdit
    self.recordIDToEdit = -1;
    
    // perform the segue
    [self performSegueWithIdentifier:@"idSegueAddPlayer" sender:self];
}


-(void)loadData {
    // form the query
    NSString *query = @"select * from players";
    
    // get the result
    if (self.arrPlayer != nil) {
        self.arrPlayer = nil;
    }
    self.arrPlayer = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // reload table view
    [self.tblPlayer reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrPlayer.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // dequeue the cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"@idCellRecord" forIndexPath:indexPath];
    
    NSInteger indexOfFirstname = [self.dbManager.arrColumnNames indexOfObject:@"firstname"];
    NSInteger indexOfLastname = [self.dbManager.arrColumnNames indexOfObject:@"lastname"];
                                 
    // set the loaded data to the appropriate cell labels
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [[self.arrPlayer objectAtIndex:indexPath.row] objectAtIndex:indexOfFirstname], [[self.arrPlayer objectAtIndex:indexPath.row] objectAtIndex:indexOfLastname]];
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    // get the record ID of the selected name and set it to the recordIDToEdit property
    self.recordIDToEdit = [[[self.arrPlayer objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    
    // perform the segue
    [self performSegueWithIdentifier:@"idSegueAddPlayer" sender:self];
}

-(void)editingInfoWasFinished {
    // reload the data
    [self loadData];
}

@end