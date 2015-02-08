//
//  TweetDetailViewController.m
//  TwitterDemo
//
//  Created by Tejas Lagvankar on 2/7/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+TimeAgo.h"

@interface TweetDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numRetweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFavoriteLabel;

@end

@implementation TweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Tweet";
    [self hydrateData];
}

#pragma mark - Private methods

- (void)hydrateData {
    self.userNameLabel.text = self.tweet.author.name;
    self.userHandleLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.author.screenName];
    self.tweetLabel.text = self.tweet.text;
    [self.userImageView setImageWithURL:[NSURL URLWithString: self.tweet.author.profileImageUrl]];
    self.tweetTimeLabel.text = [self.tweet.createdAt timeAgo];
    self.numRetweetsLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.numFavoriteLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
}


@end
