//
//  AppDelegate.h
//  TwitterDemo
//
//  Created by Tejas Lagvankar on 2/2/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PKRevealController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


- (UIViewController *)viewControllerAfterSuccessfulLogin;
@end

