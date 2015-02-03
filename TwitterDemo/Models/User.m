//
// Created by Tejas Lagvankar on 2/3/15.
// Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "User.h"


@implementation User {

}
- (id)initWithDictionary:(NSDictionary *)dictionary {

    self = [super init];
    if (self) {

        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profileImageUrl = dictionary[@"profile_image_url"];
        self.tagline = dictionary[@"description"];
    }

    return self;
}

@end