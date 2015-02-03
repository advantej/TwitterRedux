//
// Created by Tejas Lagvankar on 2/3/15.
// Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *tagline;

- (id) initWithDictionary:(NSDictionary *)dictionary;

@end