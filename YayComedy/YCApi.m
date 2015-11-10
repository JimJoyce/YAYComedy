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
#import "YCUser.h"
#import "YCLoginViewController.h"
#import "KeychainWrapper.h"
#import "YCCellTableViewCell.h"

static NSString * const articlesUrl = @"http://www.yaycomedy.com/api/articles";
static NSString * const loginUrl = @"http://www.yaycomedy.com/api/v1/login";
static NSString * const upvoteUrl = @"http://www.yaycomedy.com/api/v1/articles/%i/votes";
static NSString * const downVoteUrl = @"http://www.yaycomedy.com/api/v1/articles/%i/votes/downvote";

//------------------------------------------------------------------------------------------------

static NSString * const testArticlesUrl = @"http://localhost:3000/api/v1/articles";
static NSString * const testLoginUrl = @"http://localhost:3000/api/v1/login";
static NSString * const testVoteUrl = @"http://localhost:3000/api/v1/articles/%@/votes";
static NSString * const testDownvoteUrl = @"http://localhost:3000/api/v1/articles/%i/votes/downvote";

@implementation YCApi

+ (YCApi *)sharedInstance {
    static YCApi *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YCApi alloc]init];
    });
    return instance;
}

-(id)init {
  self = [super init];
  if (self) {
    self.didLogin = NO;
  }
  return self;
}

-(void)fetchArticles:(YCListViewController *)sender {
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
  NSLog(@"about to fetch articles");
    [requestManager GET:testArticlesUrl parameters:[self userParams] success:^(AFHTTPRequestOperation *successOperation, NSArray *responseObject) {
      self.articles = [NSMutableArray arrayWithArray:responseObject];
        [sender responseDone];
        [sender.tableView setUserInteractionEnabled:YES];
        [sender.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *failOperation, NSError *error) {
        [self generateError:sender];
    }];
}

-(void)fetchArticlesWithBlock:(requestFinishedBlock)requestFinished {
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    [requestManager GET:testArticlesUrl parameters:[self userParams] success:^(AFHTTPRequestOperation *successOperation, NSArray *responseObject) {
        self.articles = [NSMutableArray arrayWithArray:responseObject];
      
        requestFinished(YES);
    } failure:^(AFHTTPRequestOperation *failOperation, NSError *error) {
    }];
}

-(void)login:(NSDictionary *)userParams withCompletionBlock:(requestFinishedBlock)requestFinished {
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    __block NSString *plainTextPass = [userParams objectForKey:@"password"];
    [mgr POST:testLoginUrl parameters:userParams success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary * _Nonnull responseObject) {
        YCUser *user = [YCUser sharedInstance];
        NSMutableDictionary *params = [responseObject[@"user"] mutableCopy];
        params[@"password"] = plainTextPass;
        [user setProperties:responseObject[@"user"]];
        KeychainWrapper *keychain = [KeychainWrapper sharedInstance];
        [keychain storeUserCredentials:params];
        requestFinished(YES);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        //
        
    }];
}


-(void)loginWithKeychain:(NSDictionary *)userParams success:(requestFinishedBlock)requestFinished {
  NSLog(@"About to login with user credentials: %@", userParams);
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr POST:testLoginUrl parameters:userParams success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary * _Nonnull responseObject) {
        YCUser *user = [YCUser sharedInstance];
        [user setAuthToken:[[responseObject objectForKey:@"user"] objectForKey:@"auth_token"]];
        requestFinished(YES);
      self.didLogin = YES;
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        //
        
    }];
}


-(void)castVote:(NSMutableDictionary *)params fromCell:(YCCellTableViewCell *)senderCell successBlock:(requestFinishedBlock)requestFinished {
  
  NSString *formattedRoute = [NSString stringWithFormat:testVoteUrl, params[@"article_id"]];
  AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
  __block YCCellTableViewCell *sender = senderCell;
  
  
  [mgr POST:formattedRoute parameters:[self paramsWithAuthToken:params]
    success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
      
      
    NSLog(@"%@", responseObject[@"message"]);
    // update cell
    senderCell.voteId = responseObject[@"vote_id"];
    
    // update article array in case info gets lost with recursive cells.
    NSMutableDictionary *currentArticle = [NSMutableDictionary dictionaryWithDictionary:self.articles[sender.arrayIndex]];
    [currentArticle setObject:responseObject[@"vote_id"] forKey:@"vote_id"];
    [self.articles replaceObjectAtIndex:sender.arrayIndex withObject:currentArticle];
    
    requestFinished(YES);
    
  } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    //
  }];
}

-(NSDictionary *)paramsWithAuthToken:(NSMutableDictionary *)params {
  params[@"auth_token"] = [[YCUser sharedInstance] authToken];
  return [NSDictionary dictionaryWithDictionary:params];
}


-(void)generateError:(YCListViewController *)sender {
  // TODO: sender and message should be able to be dynamically defined.
  
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Server Error"
                                                                    message:@"Sorry! Something went wrong. Tap okay to try again."
                                                             preferredStyle: UIAlertControllerStyleAlert];
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


-(NSDictionary *)userParams {
    YCUser *user = [YCUser sharedInstance];
    if (user.authToken == NULL) {
        return NULL;
    }
    return @{@"auth_token" : user.authToken};
}

@end
