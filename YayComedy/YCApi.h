//
//  YCApi.h
//  YayComedy
//
//  Created by Jim Joyce on 7/3/15.
//  Copyright (c) 2015 Yay Comedy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YCListViewController;
@class YCLoginViewController;
@interface YCApi : NSObject

@property (strong, nonatomic) NSMutableArray * articles;
typedef void(^requestFinishedBlock)(BOOL);
@property BOOL didLogin;
-(void)fetchArticles:(YCListViewController *)sender;
-(void)fetchArticlesWithBlock:(requestFinishedBlock)requestFinished;
-(void)castVote:(NSMutableDictionary *)params fromCell:(id)senderCell successBlock:(requestFinishedBlock)requestFinished;
//-(void)upvoteArticle:(id)sender withArticleId:(int)articleId successBlock:(requestFinishedBlock)requestFinished;
//-(void)downvoteArticle:(id)sender withArticleId:(int)articleId successBlock:(requestFinishedBlock)requestFinished;
-(void)login:(NSDictionary *)userParams withCompletionBlock:(requestFinishedBlock)requestFinished;
-(void)loginWithKeychain:(NSDictionary *)userParams success:(requestFinishedBlock)requestFinished;
+ (YCApi *)sharedInstance;

@end
