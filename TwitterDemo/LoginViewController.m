//
//  LoginViewController.m
//  TwitterDemo
//
//  Created by Tejas Lagvankar on 2/3/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogin:(id)sender {
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
       if (user != nil) {
           //Modally present the tweets view
           AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
           [self presentViewController:[appDelegate viewControllerAfterSuccessfulLogin] animated:YES completion:nil];

       } else {
           // Present error view
           NSLog(@"Error %@", error.description);
       }
    }];
}

@end
