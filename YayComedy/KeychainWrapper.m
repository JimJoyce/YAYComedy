//
//  KeychainWrapper.m
//  YayComedy
//
//  Created by Jim Joyce on 11/4/15.
//  Copyright © 2015 Yay Comedy. All rights reserved.
//

#import "KeychainWrapper.h"

static NSString * const keychainWebsite = @"http://yaycomedy.com";

@implementation KeychainWrapper

+(KeychainWrapper *)sharedInstance {
    static KeychainWrapper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[KeychainWrapper alloc]init];
    });
    return instance;
}

-(NSDictionary *)keychainClassTypeDictionary {
    return @{
             @"genericPassword" : (__bridge id)kSecClassGenericPassword,
             @"internetPassword" : (__bridge id)kSecClassInternetPassword,
             @"certificate" : (__bridge id)kSecClassCertificate,
             @"cryptoKey" : (__bridge id)kSecClassKey,
             @"certAndKey" : (__bridge id)kSecClassIdentity
             };
}

-(NSMutableDictionary *)getStandartDictForInternetPassword {
    NSMutableDictionary *searchDictionary = [NSMutableDictionary dictionary];
    searchDictionary[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
    searchDictionary[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
    searchDictionary[(__bridge id)kSecAttrServer] = keychainWebsite;
    return searchDictionary;
}

-(BOOL)checkKeychainForExistingPassword {
    NSMutableDictionary *keychainItem = [self getStandartDictForInternetPassword];
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr) {
        NSLog(@"User credentials found.");
        return TRUE;
    }
    NSLog(@"User credentials not found.");
    return FALSE;
}

-(void)storeUserCredentials:(NSMutableDictionary *)params {
    NSMutableDictionary *keychainItem = [self getStandartDictForInternetPassword];
    keychainItem[(__bridge id)kSecAttrAccount] = params[@"username"];
    keychainItem[(__bridge id)kSecAttrLabel] = params[@"auth_token"];
    keychainItem[(__bridge id)kSecValueData] = [params[@"password"] dataUsingEncoding:NSUTF8StringEncoding];
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
    NSLog(@"Storing new credentials -- Error Code: %d", (int)status);
    
    
}

-(NSDictionary *)fetchUserDetails {
    NSMutableDictionary *keychainItem = [self getStandartDictForInternetPassword];
    NSDictionary *formattedResults;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr) {
        keychainItem[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
        keychainItem[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
        
        CFDictionaryRef result = nil;
        
        OSStatus sts = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, (CFTypeRef *)&result);
        
        NSLog(@"Fetched user details -- Error Code: %d", (int)sts);
        
        if(sts == noErr) {
            NSDictionary *resultDict = (__bridge_transfer NSDictionary *)result;
            NSData *pswd = resultDict[(__bridge id)kSecValueData];
            NSString *userName = resultDict[(__bridge id)kSecAttrAccount];
            NSString *password = [[NSString alloc] initWithData:pswd encoding:NSUTF8StringEncoding];
            formattedResults = @{@"username" : userName, @"password" : password};
            
        }
    }
    return formattedResults;
}

@end