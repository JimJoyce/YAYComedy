//
//  YCReaderViewController.m
//  YayComedy
//
//  Created by Jim Joyce on 7/8/15.
//  Copyright (c) 2015 Yay Comedy. All rights reserved.
//

#import "YCReaderViewController.h"

@interface YCReaderViewController()<UIWebViewDelegate>

@end

@implementation YCReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView setDelegate:self];
    self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    [self.navigationController.navigationBar setBarTintColor:self.barColor];
    self.closeButton.tintColor = [UIColor whiteColor];
    self.navBar.title = self.sourceText;
    [self checkSource];
}

-(void)loadWebPage:(NSString *)url {
    NSURL *urlFromString = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlFromString];
    [self.webView loadRequest:request];
}


-(void)checkSource {
    if ([self.sourceText isEqualToString:@"Paste"]) {
        self.articleUrl = [NSString stringWithFormat:@"http://%@", self.articleUrl];
        [self loadWebPage:self.articleUrl];
        
    }else if ([self.sourceText isEqualToString:@"Laughspin"]) {
        NSString *fullBodyHtml = [NSString stringWithContentsOfURL:[NSURL URLWithString:self.articleUrl]
                                                          encoding:NSUTF8StringEncoding
                                                             error:nil];
        NSString *linkTagsHtml = [self scanString:fullBodyHtml
                                           startTag:@"<head>"
                                             endTag:@"</head>"];
        NSString *singlePostHtml = [self scanString:fullBodyHtml
                                           startTag:@"<div id=\"the_body\" >"
                                             endTag:@"<!-- post #end -->"];
        NSString *finalPostHtml = [NSString stringWithFormat:
                                   @"<div id=\"the_body\" style=\"width: 100%%;\"> %@ </div>",
                                   singlePostHtml];
        NSString *finalHtml = [linkTagsHtml stringByAppendingString:finalPostHtml];
        [self.webView loadHTMLString:finalHtml baseURL:[NSURL URLWithString:self.articleUrl]];
    }else {
        [self loadWebPage:self.articleUrl];
    }
}


- (NSString *)scanString:(NSString *)string startTag:(NSString *)startTag endTag:(NSString *)endTag {
    
    NSString* scanString = @"";
    
    if (string.length > 0) {
        
        NSScanner* scanner = [[NSScanner alloc] initWithString:string];
        
        @try {
            [scanner scanUpToString:startTag intoString:nil];
            scanner.scanLocation += [startTag length];
            [scanner scanUpToString:endTag intoString:&scanString];
        }
        @catch (NSException *exception) {
            return nil;
        }
        @finally {
            return scanString;
        }
        
    }
    
    return scanString;
    
}

- (IBAction)closeReader:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showShareSheet:(id)sender {
    UIActivityViewController *shareSheet = [[UIActivityViewController alloc]initWithActivityItems:@[] applicationActivities:nil];
    [self presentViewController:shareSheet animated:YES completion:nil];
}


@end
