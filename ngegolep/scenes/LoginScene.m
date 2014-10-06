//
//  LoginScene.m
//  ngegolep
//
//  Created by Rukmono Erwan on 9/24/14.
//  Copyright (c) 2014 palawamaya. All rights reserved.
//

#import "LoginScene.h"

@interface LoginScene ()

@end

@implementation LoginScene

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)noLoginWarning:(id)sender {
    UIAlertView *noLogin = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Since you didn't login, cannot save any game result" delegate:nil cancelButtonTitle:@"What ever..." otherButtonTitles:nil, nil];
    
    [noLogin show];
}
@end
