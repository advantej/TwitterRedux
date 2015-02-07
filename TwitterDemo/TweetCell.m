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

@interface TweetCell()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *twitterHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;

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

    self.userNameLabel.text = self.tweet.author.name;
    self.twitterHandleLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.author.screenName];
    self.tweetLabel.text = self.tweet.text;
    [self.userImageView setImageWithURL:[NSURL URLWithString: self.tweet.author.profileImageUrl]];
    self.timeLabel.text = [self.tweet.createdAt timeAgoSimple];
    //TODO add more

}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width;
}


@end
