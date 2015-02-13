//
// Created by Tejas Lagvankar on 2/3/15.
// Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserDidLoginNotification;
extern NSString * const UserDidLogoutNotification;

@interface User : NSObject

@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *profileBackgroundUrl;
@property (nonatomic, strong) NSString *tagline;
@property (nonatomic, assign) NSInteger followerCount;
@property (nonatomic, assign) NSInteger followingCount;
@property (nonatomic, assign) NSInteger tweetCount;

- (id) initWithDictionary:(NSDictionary *)dictionary;

+ (User *) currentUser;
+ (void)setCurrentUser:(User *) currentUser;

+ (void)logout;
@end