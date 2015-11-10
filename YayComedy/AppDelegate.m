//
//  AppDelegate.m
//  YayComedy
//
//  Created by Jim Joyce on 7/3/15.
//  Copyright (c) 2015 Yay Comedy. All rights reserved.
//

#import "AppDelegate.h"
#import "YCApi.h"
#import <Security/Security.h>
#import "KeychainWrapper.h"
#import "YCUser.h"
#import "YCListViewController.h"
#import "YCLoadingView.h"


@interface AppDelegate () {
  YCLoginViewController *rootViewController;
  YCLoadingView *loadingView;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setUpAppearance];
  YCListViewController *rootView = (YCListViewController *)self.window.rootViewController;
    KeychainWrapper *keychain = [KeychainWrapper sharedInstance];
    if ([keychain checkKeychainForExistingPassword]) {
        NSDictionary *userRecord = [keychain fetchUserDetails];
        [[YCUser sharedInstance] setProperties:userRecord];
        YCApi *api = [YCApi sharedInstance];
        [api loginWithKeychain:userRecord success:^(BOOL requestFinished) {
            if (requestFinished) {
              [api setDidLogin:YES];
              [api fetchArticles:rootView];
            }
        }];
      return YES;
    }
  [[YCApi sharedInstance] fetchArticles:rootView];
    return YES;
}
-(void)setUpAppearance {
    UINavigationBar *navBarAppearance = [UINavigationBar appearance];
    UIFont *mainFont = [UIFont fontWithName:@"LoveloBlack" size:25.0f];
    [navBarAppearance setTitleTextAttributes:@{NSFontAttributeName : mainFont,
                                               NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
