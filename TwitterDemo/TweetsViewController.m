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

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *uiRefreshControl;

@property (nonatomic, strong) NSArray *tweets;

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

    self.uiRefreshControl = [[UIRefreshControl alloc] init];
    [self.uiRefreshControl addTarget:self action:@selector(refreshTweets) forControlEvents:UIControlEventValueChanged];

    [self setUpNavigationBar];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView insertSubview:self.uiRefreshControl atIndex:0];

    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshTweets];
}


+ (UINavigationController *) getWrappedTweetsController {
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] init]];
    nvc.navigationBar.barTintColor = [UIColor colorWithRed:19.0 / 255.0 green:207.0 / 255.0 blue:232.0 / 255.0 alpha:1];
    nvc.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    return nvc;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - private methods

- (void)refreshTweets {
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        self.tweets = tweets;
        [self.tableView reloadData];
        [self.uiRefreshControl endRefreshing];
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
    [self.navigationController presentViewController:[[ComposeViewController alloc] init] animated:YES completion:nil];
}

@end
