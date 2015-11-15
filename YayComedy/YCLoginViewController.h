//
//  YCLoginViewController.h
//  YayComedy
//
//  Created by Jim Joyce on 11/3/15.
//  Copyright © 2015 Yay Comedy. All rights reserved.
//
#import <UIKit/UIKit.h>
@class YCLoadingView;
@interface YCLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
-(void)makeApiCall;

@end
