//
//  YCReaderViewController.h
//  YayComedy
//
//  Created by Jim Joyce on 7/8/15.
//  Copyright (c) 2015 Yay Comedy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCReaderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@property (strong, nonatomic) NSString *sourceText;
@property (strong, nonatomic) NSString *articleUrl;

@end
