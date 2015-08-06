//
//  YCApi.m
//  YayComedy
//
//  Created by Jim Joyce on 7/3/15.
//  Copyright (c) 2015 Yay Comedy. All rights reserved.
//

#import "YCApi.h"
#import "YCListViewController.h"
#import "AFNetworking.h"

static NSString * const apiUrl = @"https://yaycomedy.herokuapp.com/api/articles";

@implementation YCApi

+ (YCApi *)sharedInstance {
    static YCApi *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YCApi alloc]init];
    });
    return instance;
}

-(void)fetchArticles:(YCListViewController *)sender {
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    [requestManager GET:apiUrl parameters:NULL success:^(AFHTTPRequestOperation *successOperation, NSArray *responseObject) {
        self.articles = responseObject;
        [sender responseDone];
        [sender.tableView setUserInteractionEnabled:YES];
        [sender.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *failOperation, NSError *error) {
        [self generateError:sender];
    }];
}

-(void)generateError:(YCListViewController *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Server Error"
                                                                    message:@"Sorry! Something went wrong. Tap okay to try again."
                                                             preferredStyle:
                                UIAlertControllerStyleAlert];
    UIAlertAction *okayButton = [UIAlertAction actionWithTitle:@"Okay"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            [self fetchArticles:sender];
                                                        }];
    [alert addAction:okayButton];
    [sender presentViewController:alert
                         animated:YES
                       completion:nil];
}

@end
