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
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];

}

- (void)postTweetWithStatus:(NSString *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion {

    NSDictionary *params = @{@"status" : tweet};

    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet1 = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet1, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}


@end
