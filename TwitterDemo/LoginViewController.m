//
//  LoginViewController.m
//  TwitterDemo
//
//  Created by Tejas Lagvankar on 2/3/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"

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
    TwitterClient *twitterClient = [TwitterClient sharedInstance];

    [twitterClient.requestSerializer removeAccessToken];
    [twitterClient fetchRequestTokenWithPath:@"oauth/request_token"
                                      method:@"GET"
                                 callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"]
                                       scope:nil
                                     success:^(BDBOAuth1Credential *requestToken) {
                                         NSLog(@"Got request Token");

                                         NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:
                                         @"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];

                                         [[UIApplication sharedApplication] openURL:authURL];
                                     }
                                     failure:^(NSError *error) {
                                         NSLog(@"Error getting request Token");
                                     }];
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
