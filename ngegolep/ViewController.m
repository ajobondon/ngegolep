//
//  ViewController.m
//  ngegolep
//
//  Created by Rukmono Erwan on 9/24/14.
//  Copyright (c) 2014 palawamaya. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Welcome web page
    NSURL *welcomePage = [[NSURL alloc] initWithString:@"http://www.google.com/"];
    NSURLRequest *webRequest = [[NSURLRequest alloc] initWithURL:welcomePage];
    self.welcomeWebView.scalesPageToFit = YES;
    [self.welcomeWebView loadRequest:webRequest];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
