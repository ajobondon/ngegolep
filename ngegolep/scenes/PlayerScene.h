//
//  PlayerScene.h
//  ngegolep
//
//  Created by Rukmono Erwan on 9/25/14.
//  Copyright (c) 2014 palawamaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddPlayerScene.h"

@interface PlayerScene : UITableViewController <UITableViewDelegate, UITableViewDataSource, AddPlayerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblPlayer;

-(IBAction) addNewRecord:(id)sender;

@end