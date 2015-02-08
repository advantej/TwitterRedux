//
//  ComposeViewController.h
//  TwitterDemo
//
//  Created by Tejas Lagvankar on 2/7/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Tweet.h"


@interface ComposeViewController : UIViewController

@property (nonatomic, strong) Tweet *replyToTweet;

@end
