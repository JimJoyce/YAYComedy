//
//  YCApi.h
//  YayComedy
//
//  Created by Jim Joyce on 7/3/15.
//  Copyright (c) 2015 Yay Comedy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YCListViewController;
@interface YCApi : NSObject

@property (strong, nonatomic) NSArray * articles;

-(void)fetchArticles:(YCListViewController *)sender;

+ (YCApi *)sharedInstance;

@end
