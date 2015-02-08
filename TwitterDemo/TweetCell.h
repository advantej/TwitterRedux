//
//  TweetCell.h
//  TwitterDemo
//
//  Created by Tejas Lagvankar on 2/7/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class TweetCell;

@protocol TweetCellDelegate

- (void) tweetCell:(TweetCell *) tweetCell replyPressedForTweet:(Tweet *) tweet;

@end

@interface TweetCell : UITableViewCell

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, weak) id<TweetCellDelegate> delegate;

@end
