//
//  ProfileHeaderViewController.m
//  TwitterDemo
//
//  Created by Tejas Lagvankar on 2/11/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "ProfileHeaderViewController.h"

@interface ProfileHeaderViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userBackGround;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@end

@implementation ProfileHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.userProfileImage setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    [self.userBackGround setImageWithURL:[NSURL URLWithString:self.user.profileBackgroundUrl]];
    self.userNameLabel.text = self.user.name;
    self.userScreenNameLabel.text = self.user.screenName;
    self.tweetCountLabel.text = [NSString stringWithFormat:@"%d", self.user.tweetCount];
    self.followersCountLabel.text = [NSString stringWithFormat:@"%d", self.user.followerCount];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%d", self.user.followingCount];
}

@end
