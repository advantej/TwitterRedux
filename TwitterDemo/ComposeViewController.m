//
//  ComposeViewController.m
//  TwitterDemo
//
//  Created by Tejas Lagvankar on 2/7/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "TwitterClient.h"

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *crossImageView;
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;
@property (weak, nonatomic) IBOutlet UILabel *charCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UILabel *userHandleLabel;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpBackButton];
    [self setUpUserDetails];

    self.tweetTextView.delegate = self;
    self.charCountLabel.text = @"140";

    [self.tweetTextView becomeFirstResponder];
}

#pragma mark - TextView delegate methods

- (void)textViewDidChange:(UITextView *)textView {
    self.charCountLabel.text = [NSString stringWithFormat:@"%u",140 - textView.text.length];
}

#pragma mark - Private Methods

- (IBAction)onTweetButtonPressed:(id)sender {

    [[TwitterClient sharedInstance] postTweetWithStatus:self.tweetTextView.text completion:^(Tweet *tweet, NSError *error) {
        if (tweet != nil) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void) onBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setUpUserDetails {
    User *user = [User currentUser];
    if (user) {
        self.userNameLabel.text = user.name;
        self.userHandleLabel.text = user.screenName;
        [self.userImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    } else {
        // Terribly wrong situation. Panic
    }

}

- (void) setUpBackButton {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackButton)];
    [self.crossImageView addGestureRecognizer:singleTap];
    [self.crossImageView setMultipleTouchEnabled:YES];
    [self.crossImageView setUserInteractionEnabled:YES];
}


@end
