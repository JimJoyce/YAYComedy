//
//  YCUser.h
//  YayComedy
//
//  Created by Jim Joyce on 11/4/15.
//  Copyright © 2015 Yay Comedy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCUser : NSObject

@property(strong, nonatomic)NSString *authToken;
@property(weak, nonatomic)NSString *username;
@property(weak, nonatomic)NSURLProtectionSpace *protectionSpace;
+(YCUser *)sharedInstance;
-(void)setProperties:(NSDictionary *)userObject;

@end
