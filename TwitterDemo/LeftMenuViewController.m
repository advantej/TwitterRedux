//
//  LeftMenuViewController.m
//  TwitterDemo
//
//  Created by Tejas Lagvankar on 2/10/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "LeftMenuViewController.h"
#import "ProfileCell.h"
#import "MenuCell.h"
#import "User.h"

@interface LeftMenuViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) ProfileCell *dummyProfileCell;
@property (weak, nonatomic) MenuCell *dummyMenuCell;

@end

@implementation LeftMenuViewController

- (ProfileCell *)dummyProfileCell {

    if (!_dummyProfileCell) {
        _dummyProfileCell = [self.tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
    }
    return _dummyProfileCell;

}

- (MenuCell *)dummyMenuCell {

    if (!_dummyMenuCell) {
        _dummyMenuCell = [self.tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    }
    return _dummyMenuCell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:nil] forCellReuseIdentifier:@"ProfileCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"MenuCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.tableView.rowHeight = UITableViewAutomaticDimension;

    [self.tableView reloadData];

}

#pragma mark - TableView DataSource Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileCell *profileCell;
    MenuCell *menuCell;
    switch (indexPath.row) {
        case 0:
            profileCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
            [profileCell.userImageView setImageWithURL:[NSURL URLWithString:[[User currentUser] profileImageUrl]]];
            profileCell.usernameLabel.text = [[User currentUser] name];
            profileCell.userHandleLabel.text = [[User currentUser] screenName];
            return profileCell;
        case 1:
            menuCell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
            menuCell.menuLabel.text = @"Home";
            return menuCell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self configureCell:self.dummyProfileCell forRowAtIndexPath:indexPath];
            [self.dummyProfileCell layoutIfNeeded];

            CGSize size = [self.dummyProfileCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            return size.height+1;

        case 1:
            [self configureCell:self.dummyMenuCell forRowAtIndexPath:indexPath];
            [self.dummyMenuCell layoutIfNeeded];

            CGSize size1 = [self.dummyMenuCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            return size1.height+1;

    }

    return 0;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[ProfileCell class]]) {
        ProfileCell *profileCell = (ProfileCell*)cell;
        [profileCell.userImageView setImageWithURL:[NSURL URLWithString:[[User currentUser] profileImageUrl]]];
        profileCell.usernameLabel.text = [[User currentUser] name];
        profileCell.userHandleLabel.text = [[User currentUser] screenName];
    } else if ([cell isKindOfClass:[MenuCell class]]) {
        MenuCell *menuCell = (MenuCell*)cell;
        menuCell.menuLabel.text = @"Home";
    }
}


#pragma mark - TableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 1) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"user_profile_requested" object:nil]];
    }

}


#pragma mark - Private Methods


@end
