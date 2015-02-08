//
// Created by Tejas Lagvankar on 2/3/15.
// Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "Tweet.h"


@implementation Tweet {

}
- (id)initWithDictionary:(NSDictionary *)dictionary {

    self = [super init];

    if (self) {

        self.idStr = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        self.author = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.retweetCount = [dictionary[@"retweet_count"] integerValue];
        self.favoriteCount = [dictionary[@"favorite_count"] integerValue];

        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createdAtString];

    }

    return self;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {

    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in array) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    return tweets;
}


@end