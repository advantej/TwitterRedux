//
//  TwitterClient.m
//  TwitterDemo
//
//  Created by Tejas Lagvankar on 2/3/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString *const kTwitterConsumerKey = @"bZ9yS4dKrnzx6eguQXcL4jcsL";
NSString *const kTwitterConsumerSecret = @"QmNKQrYPYKvn1eI7xV1T8GlwLzjoNMyzELrQKbDhHk7stNGNWW";
NSString *const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient ()

@property(nonatomic, strong) void (^loginCompletion)(User *, NSError *);

@end

@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    return instance;
}

- (void)loginWithCompletion:(void (^)(User *, NSError *))completion {

    self.loginCompletion = completion;

    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token"
                             method:@"GET"
                        callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"]
                              scope:nil
                            success:^(BDBOAuth1Credential *requestToken) {
                                NSLog(@"Got request Token");

                                NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:
                                        @"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];

                                [[UIApplication sharedApplication] openURL:authURL];
                            }
                            failure:^(NSError *error) {
                                self.loginCompletion(nil, error);
                            }];

}


- (void)openURL:(NSURL *)url {

    [self fetchAccessTokenWithPath:@"oauth/access_token"
                            method:@"POST"
                      requestToken:[BDBOAuth1Credential
                              credentialWithQueryString:url.query]

                           success:^(BDBOAuth1Credential *accessToken) {
                               NSLog(@"Got the access Token");

                               [self.requestSerializer saveAccessToken:accessToken];

                               [self GET:@"1.1/account/verify_credentials.json" parameters:nil
                                                           success:^(AFHTTPRequestOperation *operation, id responseObject) {

                                                               User *user = [[User alloc] initWithDictionary:responseObject];
                                                               [User setCurrentUser:user]; //persist the user
                                                               self.loginCompletion(user, nil);

                                                           }
                                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                               self.loginCompletion(nil, error);
                                                           }];
                           }
                           failure:^(NSError *error) {
                               self.loginCompletion(nil, error);
                           }];
}

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    //[self GET:@"1.1/statuses/home_timeline.json?count=200" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    [self GET:@"1.1/statuses/home_timeline.json?count=20" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];

}

- (void)userTimelineWithScreenName:(NSString *)screenName params:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"screen_name"] = screenName;
    [parameters addEntriesFromDictionary:params];

    [self GET:@"1.1/statuses/user_timeline.json?count=20" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];

}

- (void)getSingleTweetWithId:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion {

    NSDictionary *params = @{@"id" : tweetId};

    [self GET:@"1.1/statuses/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet1 = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet1, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)postTweetWithStatus:(NSString *)status replyToTweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion {

    NSMutableDictionary *params = [@{@"status" : status} mutableCopy];

    if (tweet != nil) {
        [params addEntriesFromDictionary:@{@"in_reply_to_status_id" : tweet.idStr}];
    }

    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet1 = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet1, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

//Note from the docs : The immediately returned status may not indicate the resultant favorited status of the tweet.
//A 200 OK response from this method will indicate whether the intended action was successful or not.
- (void)favoriteTweetWithId:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion {

    NSDictionary *params = @{@"id" : tweetId};

    [self POST:@"1.1/favorites/create.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet1 = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet1, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}


//Note from the docs : The immediately returned status may not indicate the resultant favorited status of the tweet.
//A 200 OK response from this method will indicate whether the intended action was successful or not.
- (void)unFavoriteTweetWithId:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion {

    NSDictionary *params = @{@"id" : tweetId};

    [self POST:@"1.1/favorites/destroy.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet1 = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet1, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)reTweetTweetWithId:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion {

    NSString *url = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetId];

    [self POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet1 = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet1, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}


@end
