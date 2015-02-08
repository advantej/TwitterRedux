//
//  TweetCell.m
//  TwitterDemo
//
//  Created by Tejas Lagvankar on 2/7/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+TimeAgo.h"
#import "TwitterClient.h"
#import "ComposeViewController.h"

@interface TweetCell()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *twitterHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *replyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImageView;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;

@property (nonatomic, assign) BOOL canRetweet;

@end

@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
    self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;

    [self setUpActionButtons];

    self.userNameLabel.text = self.tweet.author.name;
    self.twitterHandleLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.author.screenName];
    self.tweetLabel.text = self.tweet.text;
    [self.userImageView setImageWithURL:[NSURL URLWithString: self.tweet.author.profileImageUrl]];
    self.timeLabel.text = [self.tweet.createdAt timeAgoSimple];

    if (self.tweet.favorited) {
        [self.favoriteImageView setImage:[UIImage imageNamed:@"favorite_on"]];
    } else {
        [self.favoriteImageView setImage:[UIImage imageNamed:@"favorite"]];
    }

    if ([self.tweet.author.idStr isEqualToString:[User currentUser].idStr]) {
        [self.retweetImageView setImage:[UIImage imageNamed:@"retweet_off"]];
        self.canRetweet = NO;
    } else {
        if (self.tweet.retweeted) {
            [self.retweetImageView setImage:[UIImage imageNamed:@"retweet_on"]];
        } else {
            [self.retweetImageView setImage:[UIImage imageNamed:@"retweet"]];
        }
    }

}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width;
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

- (void)onRetweetPressed {

    if (self.tweet.retweeted || !self.canRetweet)
        return;

    [[TwitterClient sharedInstance] reTweetTweetWithId:self.tweet.idStr completion:^(Tweet *tweet, NSError *error) {
        if (tweet != nil) {
            self.tweet.retweeted = YES;
            [self setTweet:tweet];
        }
    }];
}

- (void)onFavoritePressed {
    if (self.tweet.favorited) {
        [[TwitterClient sharedInstance] unFavoriteTweetWithId:self.tweet.idStr completion:^(Tweet *tweet, NSError *error) {
            if (tweet != nil) {
                self.tweet = tweet;
                self.tweet.favorited = NO;
                [self setTweet:tweet];
            }
        }];

    } else {
        [[TwitterClient sharedInstance] favoriteTweetWithId:self.tweet.idStr completion:^(Tweet *tweet, NSError *error) {
            if (tweet != nil) {
                self.tweet = tweet;
                self.tweet.favorited = YES;
                [self setTweet:tweet];
            }
        }];
    }
}

- (void) onReplyPressed {

    [self.delegate tweetCell:self replyPressedForTweet:self.tweet];
}


@end
