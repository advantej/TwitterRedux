//
//  TwitterClient.m
//  TwitterDemo
//
//  Created by Tejas Lagvankar on 2/3/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "TwitterClient.h"

NSString * const kTwitterConsumerKey = @"bZ9yS4dKrnzx6eguQXcL4jcsL";
NSString * const kTwitterConsumerSecret = @"QmNKQrYPYKvn1eI7xV1T8GlwLzjoNMyzELrQKbDhHk7stNGNWW";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

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

@end
