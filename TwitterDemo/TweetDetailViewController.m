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
#import "TwitterClient.h"

@interface TweetDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numRetweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFavoriteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImageView;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;
@property (weak, nonatomic) IBOutlet UIImageView *replyImageView;

@property (nonatomic, strong) User *currentUser;
@property (nonatomic, assign) BOOL canRetweet;

@end

@implementation TweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.currentUser = [User currentUser];

    self.canRetweet = YES;
    if ([self.tweet.author.idStr isEqualToString:self.currentUser.idStr]) {
        self.canRetweet = NO;
    }

    self.title = @"Tweet";
    [self hydrateData];

    [self setUpActionButtons];

    [self refreshTweet];
}

#pragma mark - Private methods

- (void)onRetweetPressed {

    if (self.tweet.retweeted || !self.canRetweet)
        return;

    [[TwitterClient sharedInstance] reTweetTweetWithId:self.tweet.idStr completion:^(Tweet *tweet, NSError *error) {
        if (tweet != nil) {
            self.tweet.retweeted = YES;
            self.tweet.retweetCount = self.tweet.retweetCount + 1;
            [self hydrateData];
        }
    }];
}

- (void)onFavoritePressed {
    int favCount = self.tweet.favoriteCount;
    if (self.tweet.favorited) {
        [[TwitterClient sharedInstance] unFavoriteTweetWithId:self.tweet.idStr completion:^(Tweet *tweet, NSError *error) {
            if (tweet != nil) {
                self.tweet = tweet;
                self.tweet.favorited = NO;
                self.tweet.favoriteCount = favCount - 1;
                [self hydrateData];
            }
        }];

    } else {
        [[TwitterClient sharedInstance] favoriteTweetWithId:self.tweet.idStr completion:^(Tweet *tweet, NSError *error) {
            if (tweet != nil) {
                self.tweet = tweet;
                self.tweet.favorited = YES;
                self.tweet.favoriteCount = favCount + 1;
                [self hydrateData];
            }
        }];
    }
}

- (void) onReplyPressed {

}



- (void)refreshTweet {
    [[TwitterClient sharedInstance] getSingleTweetWithId:self.tweet.idStr completion:^(Tweet *tweet, NSError *error) {
        if (tweet != nil) {
            self.tweet = tweet;
            [self hydrateData];
        }
    }];

}


- (void)hydrateData {
    self.userNameLabel.text = self.tweet.author.name;
    self.userHandleLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.author.screenName];
    self.tweetLabel.text = self.tweet.text;
    [self.userImageView setImageWithURL:[NSURL URLWithString: self.tweet.author.profileImageUrl]];
    self.tweetTimeLabel.text = [self.tweet.createdAt timeAgo];
    self.numRetweetsLabel.text = [NSString stringWithFormat:@"%ld", (long)self.tweet.retweetCount];
    self.numFavoriteLabel.text = [NSString stringWithFormat:@"%ld", (long)self.tweet.favoriteCount];

    if (self.tweet.favorited) {
        [self.favoriteImageView setImage:[UIImage imageNamed:@"favorite_on"]];
    } else {
        [self.favoriteImageView setImage:[UIImage imageNamed:@"favorite"]];
    }

    if (!self.canRetweet) {
        [self.retweetImageView setImage:[UIImage imageNamed:@"retweet_off"]];
    } else {
        if (self.tweet.retweeted) {
            [self.retweetImageView setImage:[UIImage imageNamed:@"retweet_on"]];
        } else {
            [self.retweetImageView setImage:[UIImage imageNamed:@"retweet"]];
        }
    }




}

- (void) setUpActionButtons {
    UITapGestureRecognizer *singleTapFav = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onFavoritePressed)];
    [self.favoriteImageView addGestureRecognizer:singleTapFav];
    [self.favoriteImageView setMultipleTouchEnabled:YES];
    [self.favoriteImageView setUserInteractionEnabled:YES];

    UITapGestureRecognizer *singleTapReTweet = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRetweetPressed)];
    [self.retweetImageView addGestureRecognizer:singleTapReTweet];
    [self.retweetImageView setMultipleTouchEnabled:YES];
    [self.retweetImageView setUserInteractionEnabled:YES];

    UITapGestureRecognizer *singleTapReply = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onReplyPressed)];
    [self.replyImageView addGestureRecognizer:singleTapReply];
    [self.replyImageView setMultipleTouchEnabled:YES];
    [self.replyImageView setUserInteractionEnabled:YES];
}


@end
