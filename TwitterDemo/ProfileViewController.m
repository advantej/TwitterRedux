//
//  ProfileViewController.m
//  TwitterDemo
//
//  Created by Tejas Lagvankar on 2/10/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "ProfileViewController.h"
#import "ProfileHeaderViewController.h"
#import "TwitterClient.h"
#import "TweetCell.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ProfileHeaderViewController *profileHeaderViewController;

@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) TweetCell *dummyCell;
@end

@implementation ProfileViewController

- (TweetCell *)dummyCell {

    if (!_dummyCell) {
        _dummyCell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    }
    return _dummyCell;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Profile";
    self.tweets = [NSMutableArray array];

    self.profileHeaderViewController = [[ProfileHeaderViewController alloc] init];
    self.profileHeaderViewController.user = self.user;

    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    self.tableView.tableHeaderView = self.profileHeaderViewController.view;
    self.tableView.dataSource = self;
    [self loadTweetsForUser];

}

#pragma mark - TableView DataSource Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TweetCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    tweetCell.tweet = self.tweets[indexPath.row];
    return tweetCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self configureCell:self.dummyCell forRowAtIndexPath:indexPath];
    [self.dummyCell layoutIfNeeded];

    CGSize size = [self.dummyCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[TweetCell class]])
    {
        TweetCell *textCell = (TweetCell *)cell;
        textCell.tweet = self.tweets[indexPath.row];
    }
}

#pragma mark - TableView Delegate Methods

#pragma mark - Private Methods

-(void) loadTweetsForUser {
    [[TwitterClient sharedInstance] userTimelineWithScreenName:self.user.screenName params:nil completion:^(NSArray *tweets, NSError *error) {
        [self.tweets removeAllObjects];
        [self.tweets addObjectsFromArray:tweets];
        UIView *headerView = self.profileHeaderViewController.view;
        headerView.frame = CGRectMake(0, 0, 320, 245);
        self.tableView.tableHeaderView = headerView;
        [self.tableView reloadData];
    }];
}

@end
