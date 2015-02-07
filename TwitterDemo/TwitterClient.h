//
//  TwitterClient.h
//  TwitterDemo
//
//  Created by Tejas Lagvankar on 2/3/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *) sharedInstance;

- (void) loginWithCompletion:(void (^) (User *user, NSError *error) )completion;

- (void)openURL:(NSURL *)url;

- (void)homeTimelineWithParams:(NSDictionary *) params completion:(void (^)(NSArray *tweets, NSError *error))completion;

- (void)postTweetWithStatus:(NSString *) tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;

@end
