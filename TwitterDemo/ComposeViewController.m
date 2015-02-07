//
//  ComposeViewController.m
//  TwitterDemo
//
//  Created by Tejas Lagvankar on 2/7/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "ComposeViewController.h"

@interface ComposeViewController ()

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpNavigationBar];
}

+ (UINavigationController *) getWrappedComposeViewController {
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:[[ComposeViewController alloc] init]];
    nvc.navigationBar.barTintColor = [UIColor colorWithRed:19.0 / 255.0 green:207.0 / 255.0 blue:232.0 / 255.0 alpha:1];
    nvc.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    return nvc;
}

#pragma mark - Private Methods

- (void)setUpNavigationBar {
    self.title = @"Tweet";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"X" style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweet:)];

    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];

}

- (void)onTweet:(id)onTweet {
    //TODO Post Tweet

}

- (void)onBack:(id)onBack {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
