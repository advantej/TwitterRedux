//
// Created by Tejas Lagvankar on 2/3/15.
// Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"


@interface Tweet : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) User *author;
@property (nonatomic, strong) NSDate *createdAt;

- (id) initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *) tweetsWithArray:(NSArray *)array;

@end