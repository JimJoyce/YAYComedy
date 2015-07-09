//
//  YCListViewControllerTableViewController.m
//  YayComedy
//
//  Created by Jim Joyce on 7/3/15.
//  Copyright (c) 2015 Yay Comedy. All rights reserved.
//

#import "YCListViewControllerTableViewController.h"
#import "YCCellTableViewCell.h"
#import "YCApi.h"
#import "YCReaderViewController.h"

@interface YCListViewControllerTableViewController () {
    YCApi *api;
    NSUInteger colorIndex;
    BOOL goingUp;
}

@end

@implementation YCListViewControllerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    colorIndex = 0;
    goingUp = TRUE;
    api = [[YCApi alloc]initWithArticles:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return api.articles.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 150.0f;
//}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell configureCell:[self checkColorIndex]
               withJson:[api.articles objectAtIndex:indexPath.row]];
    return cell;
}

-(NSUInteger)checkColorIndex {
    colorIndex += 1;
    if (colorIndex == 4) {
        colorIndex = 0;
        return 4;
    }
    return colorIndex;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"webViewSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        YCCellTableViewCell *cell = sender;
        UINavigationController *navigationController = segue.destinationViewController;
        YCReaderViewController *dvc = (YCReaderViewController *)navigationController.topViewController;
        
        dvc.articleUrl = [[api.articles objectAtIndex:indexPath.row] valueForKey:@"article_link"];
        dvc.sourceText = [[api.articles objectAtIndex:indexPath.row] valueForKey:@"source"];
    }
}


@end
