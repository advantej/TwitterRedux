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

- (void)userTimelineWithScreenName:(NSString *)screenName params:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;

- (void)getSingleTweetWithId:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion;

- (void)postTweetWithStatus:(NSString *)status replyToTweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;

- (void)favoriteTweetWithId:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion;

- (void)unFavoriteTweetWithId:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion;

- (void)reTweetTweetWithId:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion;
@end
