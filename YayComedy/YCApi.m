//
//  YCApi.m
//  YayComedy
//
//  Created by Jim Joyce on 7/3/15.
//  Copyright (c) 2015 Yay Comedy. All rights reserved.
//

#import "YCApi.h"
#import "AFNetworking.h"

static NSString * const apiUrl = @"https://yaycomedy.herokuapp.com/api/articles";

@implementation YCApi

-(id)initWithArticles:(UITableView *)tableView {
    self = [super init];
    if (self) {
        [self fetchArticles: tableView];
    }
    return self;
}

-(void)fetchArticles:(UITableView *)sender {
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    [requestManager GET:apiUrl parameters:NULL success:^(AFHTTPRequestOperation *successOperation, NSArray *responseObject) {
        
        NSLog(@"Successful request");
        self.articles = responseObject;
        [sender reloadData];
    } failure:^(AFHTTPRequestOperation *failOperation, NSError *error) {
        
        NSLog(@"Response failed with %@", error);
        
    }];
}

@end