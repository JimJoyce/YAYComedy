//
//  KeychainWrapper.h
//  YayComedy
//
//  Created by Jim Joyce on 11/4/15.
//  Copyright © 2015 Yay Comedy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import <CommonCrypto/CommonHMAC.h>

@interface KeychainWrapper : NSObject
+(KeychainWrapper *)sharedInstance;
-(BOOL)checkKeychainForExistingPassword;
-(NSDictionary *)fetchUserDetails;
-(void)storeUserCredentials:(NSMutableDictionary *)params;
@end