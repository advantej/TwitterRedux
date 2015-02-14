//
//  MentionsViewController.m
//  TwitterDemo
//
//  Created by Tejas Lagvankar on 2/13/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "MentionsViewController.h"
#import "TweetCell.h"
#import "TwitterClient.h"

@interface MentionsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) TweetCell *dummyCell;

@end

@implementation MentionsViewController

- (TweetCell *)dummyCell {

    if (!_dummyCell) {
        _dummyCell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    }
    return _dummyCell;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Mentions";
    self.tweets = [NSMutableArray array];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    [self refreshTweets];
}

#pragma mark - tableview datasource methods

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

#pragma mark - tableview delgate methods

#pragma mark - private methods

- (void)refreshTweets {
    [[TwitterClient sharedInstance] mentionsTimeLineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        if (error != nil) {
            return;
        }

        [self.tweets removeAllObjects];
        [self.tweets addObjectsFromArray:tweets];
        [self.tableView reloadData];
    }];
}

@end
