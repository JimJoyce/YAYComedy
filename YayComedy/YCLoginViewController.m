//
//  YCLoginViewController.m
//  YayComedy
//
//  Created by Jim Joyce on 11/3/15.
//  Copyright © 2015 Yay Comedy. All rights reserved.
//

#import "YCLoginViewController.h"
#import "YCListViewController.h"
#import "YCApi.h"
#import "YCUser.h"

@interface YCLoginViewController () {
}

@end

@implementation YCLoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  UIImageView *background = [[UIImageView alloc] initWithFrame:self.view.frame];
  [background setImage:[UIImage imageNamed:@"tableview_bg"]];
  [self.view addSubview:background];
  [self.view sendSubviewToBack:background];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (IBAction)closeLoginView:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

// intial login. save and store forever.
- (IBAction)userTappedLogin:(id)sender {
    YCApi *api = [YCApi sharedInstance];
    [api login:@{@"username" : self.userNameField.text, @"password" : self.passwordField.text} withCompletionBlock:^(BOOL requestDone) {
        if (requestDone) {
          [[YCApi sharedInstance] setDidLogin:YES];
          [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

-(void)makeApiCall {
    YCApi *api = [YCApi sharedInstance];
    [api fetchArticlesWithBlock:^(BOOL requestFinished) {
        if (requestFinished) {
//          [self performSegueWithIdentifier:@"loginSegue" sender:self];
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"loginSegue"]) {
//        YCListViewController *dvc = (YCListViewController *)segue.destinationViewController;
//        [dvc.tableView setUserInteractionEnabled:YES];
//        [dvc.tableView reloadData];
//      if ([[YCApi sharedInstance] didAutoLogin]) {
//      } 
//    }
}


@end
