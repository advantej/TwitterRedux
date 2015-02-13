//
//  TweetsViewController.m
//  TwitterDemo
//
//  Created by Tejas Lagvankar on 2/5/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "TweetDetailViewController.h"
#import "PKRevealController/PKRevealController.h"
#import "LeftMenuViewController.h"
#import "ProfileViewController.h"

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate, TweetCellDelegate, ComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *uiRefreshControl;

@property (nonatomic, strong) NSMutableArray *tweets;

@property (nonatomic, strong) TweetCell *dummyCell;

@end

@implementation TweetsViewController

- (TweetCell *)dummyCell {

    if (!_dummyCell) {
        _dummyCell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    }
    return _dummyCell;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tweets = [NSMutableArray array];

    self.uiRefreshControl = [[UIRefreshControl alloc] init];
    [self.uiRefreshControl addTarget:self action:@selector(refreshTweets) forControlEvents:UIControlEventValueChanged];

    [self setUpNavigationBar];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView insertSubview:self.uiRefreshControl atIndex:0];

    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    [self refreshTweets];
}

+ (UIViewController *) getWrappedTweetsController {
    LeftMenuViewController *menuViewController = [[LeftMenuViewController alloc] init];
    TweetsViewController *tweetsViewController = [[TweetsViewController alloc] init];

    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:tweetsViewController];
    nvc.navigationBar.barTintColor = [UIColor colorWithRed:64.0 / 255.0 green:153.0 / 255.0 blue:255.0 / 255.0 alpha:1];
    nvc.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

    PKRevealController *revealController = [PKRevealController revealControllerWithFrontViewController:nvc leftViewController:menuViewController];

    return revealController;
}


#pragma mark - TableView DataSource Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row + 3 == self.tweets.count) {
        [self getOlderTweets];
    }

    TweetCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    tweetCell.tweet = self.tweets[indexPath.row];
    tweetCell.delegate = self;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TweetDetailViewController *detailViewController = [[TweetDetailViewController alloc] init];
    detailViewController.tweet = self.tweets[indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - TweetCell delegate Methods

- (void)tweetCell:(TweetCell *)tweetCell replyPressedForTweet:(Tweet *)tweet {
    ComposeViewController *composeViewController = [[ComposeViewController alloc] init];
    composeViewController.replyToTweet = tweet;
    [self.navigationController pushViewController:composeViewController animated:YES];
}

- (void)tweetCell:(TweetCell *)tweetCell profileRequestedForUser:(User *)user {
    ProfileViewController *pvc = [[ProfileViewController alloc] init];
    pvc.user = user;
    [self.navigationController pushViewController:pvc animated:YES];
}


#pragma mark - ComposeViewController delegate Methods

- (void)successFullyPostedTweet:(Tweet *)tweet {
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

#pragma mark - private methods

- (void)refreshTweets {
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        if (error != nil) {
            [self displayError:error];
            return;
        }

        [self.tweets removeAllObjects];
        [self.tweets addObjectsFromArray:tweets];
        [self.tableView reloadData];
        [self.uiRefreshControl endRefreshing];
    }];
}

- (void)getOlderTweets {

    Tweet *lastTweet = self.tweets[self.tweets.count - 1];

    [[TwitterClient sharedInstance] homeTimelineWithParams:@{@"max_id": lastTweet.idStr} completion:^(NSArray *tweets, NSError *error) {

        if (error != nil) {
            [self displayError:error];
            return;
        }

        [self.tweets addObjectsFromArray:tweets];
        [self.tableView reloadData];
    }];
}

- (void)setUpNavigationBar {
    self.title = @"Home";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOut:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNewTweet:)];

    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];

}

- (void)onSignOut:(id)onSignOut {
    [User logout];
}

- (void)onNewTweet:(id)onNewTweet {
    ComposeViewController *composeViewController = [[ComposeViewController alloc] init];
    composeViewController.delegate = self;
    [self.navigationController presentViewController:composeViewController animated:YES completion:nil];
}

- (void) displayError:(NSError *)error {
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                     message:error.localizedDescription
                                                    delegate:self
                                           cancelButtonTitle:@"Ok"
                                           otherButtonTitles:nil];
    [alert show];
}

@end
