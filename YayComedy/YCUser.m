//
//  YCUser.m
//  YayComedy
//
//  Created by Jim Joyce on 11/4/15.
//  Copyright © 2015 Yay Comedy. All rights reserved.
//

#import "YCUser.h"

@implementation YCUser


+(YCUser *)sharedInstance {
    static YCUser *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YCUser alloc]init];
    });
    return instance;
}


//-(id)init {
//    self = [super init];
//    if (self) {
//    }
//  return self;
//}


-(void)setProperties:(NSDictionary *)userObject {
    self.username = [userObject valueForKey:@"username"];
    self.authToken = [userObject valueForKey:@"auth_token"];
    
}

@end
