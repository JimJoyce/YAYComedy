//
//  YCApi.h
//  YayComedy
//
//  Created by Jim Joyce on 7/3/15.
//  Copyright (c) 2015 Yay Comedy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"

@interface YCApi : NSObject

@property (strong, nonatomic) NSArray * articles;

-(id) initWithArticles:(UITableView *) tableView;
@end
