//
//  AppDelegate.m
//  TwitterDemo
//
//  Created by Tejas Lagvankar on 2/2/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import <PKRevealController/PKRevealController.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "Tweet.h"
#import "TweetsViewController.h"
#import "LeftMenuViewController.h"
#import "ProfileViewController.h"
#import "MentionsViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) PKRevealController *pkRevealController;
@property (nonatomic, strong) UIViewController *homeViewController;
@property (nonatomic, strong) ProfileViewController *profileViewController;
@property (nonatomic, strong) UIViewController *mentionsViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout) name:UserDidLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onHomeViewRequested:) name:@"home_requested" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onProfileRequested:) name:@"user_profile_requested" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMentionsRequested:) name:@"mentions_timeline_requested" object:nil];

    User *user = [User currentUser];
    if (user != nil) {
        NSLog(@"Welcome %@", user.name);
        self.pkRevealController = (PKRevealController *) [self viewControllerAfterSuccessfulLogin];
        self.window.rootViewController = self.pkRevealController;
    } else {
        NSLog(@"User not loggged in");
        self.window.rootViewController = [[LoginViewController alloc] init];
    }

    [self.window makeKeyAndVisible];
    return YES;
}

-(UIViewController *) viewControllerAfterSuccessfulLogin{
    self.pkRevealController = [PKRevealController revealControllerWithFrontViewController:[TweetsViewController getWrappedTweetsController] leftViewController:[[LeftMenuViewController alloc] init]];
    return self.pkRevealController;
}

- (void)onHomeViewRequested:(id)onMentionsRequested {
    if (self.homeViewController == nil) {
       self.homeViewController = [self getNvcWrappedControllerForViewController:[[TweetsViewController alloc] init]];
    }
    [self.pkRevealController setFrontViewController:self.homeViewController];
    [self.pkRevealController resignPresentationModeEntirely:YES animated:YES completion:nil];
}

- (void)onMentionsRequested:(id)onMentionsRequested {
    if (self.mentionsViewController == nil) {
        self.mentionsViewController = [self getNvcWrappedControllerForViewController:[[MentionsViewController alloc] init]];
    }
    [self.pkRevealController setFrontViewController:self.mentionsViewController];
    [self.pkRevealController resignPresentationModeEntirely:YES animated:YES completion:nil];
}

- (void)onProfileRequested:(id)o{
    if (self.profileViewController == nil) {
        self.profileViewController = [[ProfileViewController alloc] init];
    }
    self.profileViewController.user = [User currentUser];
    [self.pkRevealController setFrontViewController:self.profileViewController];
    [self.pkRevealController resignPresentationModeEntirely:YES animated:YES completion:nil];
}

- (UIViewController *) getNvcWrappedControllerForViewController:(UIViewController *) controller {

    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:controller];
    nvc.navigationBar.barTintColor = [UIColor colorWithRed:64.0 / 255.0 green:153.0 / 255.0 blue:255.0 / 255.0 alpha:1];
    nvc.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

    return nvc;
}

- (void)userDidLogout {
    self.window.rootViewController = [[LoginViewController alloc] init];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[TwitterClient sharedInstance] openURL:url];
    return YES;
}

@end
