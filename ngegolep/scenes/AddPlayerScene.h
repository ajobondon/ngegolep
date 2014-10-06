//
//  AddPlayerScene.h
//  ngegolep
//
//  Created by Rukmono Erwan on 9/25/14.
//  Copyright (c) 2014 palawamaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddPlayerControllerDelegate

-(void)editingInfoWasFinished;

@end

@interface AddPlayerScene : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtFirstname;
@property (weak, nonatomic) IBOutlet UITextField *txtLastname;

@property (nonatomic, strong) id<AddPlayerControllerDelegate> delegate;
@property (nonatomic) int recordIDToEdit;

-(IBAction)saveInfo:(id)sender;

@end
