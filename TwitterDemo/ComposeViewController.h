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

@protocol ComposeViewControllerDelegate <NSObject>

- (void)successFullyPostedTweet:(Tweet *) tweet;

@end

@interface ComposeViewController : UIViewController

@property (nonatomic, strong) Tweet *replyToTweet;
@property (weak, nonatomic) id<ComposeViewControllerDelegate> delegate;

@end
