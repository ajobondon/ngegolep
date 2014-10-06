//
//  CourseScene.m
//  ngegolep
//
//  Created by Rukmono Erwan on 9/24/14.
//  Copyright (c) 2014 palawamaya. All rights reserved.
//

#import "CourseScene.h"

@interface CourseScene ()

@end

@implementation CourseScene

- (void)viewDidLoad {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@" dd / mm / yyyy "];
    self.dateString = [dateFormatter stringFromDate:[NSDate date]];
    self.currentDate.text = self.dateString;
    
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

@end
