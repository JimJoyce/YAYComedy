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
#import "NSString+HTML.h"
#import "YCSettingsView.h"
#import "UIColor+Colors.h"

@interface YCListViewControllerTableViewController () <UIScrollViewDelegate> {
    YCApi *api;
    NSUInteger colorIndex;
    BOOL goingUp;
    UIButton *settingsIcon;
    UIImage *settingsImage;
    YCSettingsView *settingsPane;
    UIView *darkenView;
    UIButton *closeSettingsButton;
    UIColor *highlightedCellColor;
    BOOL yellowSelected;
    
    __weak IBOutlet UIRefreshControl *refresh;
}

@end

@implementation YCListViewControllerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    colorIndex = -1;
    goingUp = TRUE;
    api = [YCApi sharedInstance];
    [api fetchArticles:self.tableView];
    settingsImage = [UIImage imageNamed:@"settings.png"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CGRect settingsPos = CGRectMake(0.0,0.0,
                                    settingsImage.size.width/2,
                                    settingsImage.size.height/2);
    
    settingsIcon = [[UIButton alloc]initWithFrame:settingsPos];
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    bgImageView.image = [UIImage imageNamed:@"splash.png"];
    [settingsIcon setBackgroundImage:settingsImage forState:UIControlStateNormal];
    [self.tableView addSubview:settingsIcon];
    [self.tableView addObserver:self
                     forKeyPath:@"frame"
                        options:0
                        context:NULL];
    settingsIcon.alpha = 0.8;
    self.refreshControl = refresh;
    [self.refreshControl addSubview:bgImageView];
    [self.refreshControl sendSubviewToBack:bgImageView];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [settingsIcon addTarget:self action:@selector(openSettings) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)openSettings {
    CGRect settingsFrame = CGRectMake(0, 0,
                                      CGRectGetWidth(self.view.frame) * 0.80,
                                      CGRectGetHeight(self.view.frame) * 0.5);
    settingsFrame.origin.x = CGRectGetMidX(self.view.frame) * 0.20;
    settingsFrame.origin.y = CGRectGetMidY(self.view.frame) * 0.50;
    settingsPane = [[YCSettingsView alloc]initWithFrame: settingsFrame];
    [settingsPane setUserInteractionEnabled:YES];
    [self.tableView setScrollEnabled:NO];
    closeSettingsButton = [[UIButton alloc]initWithFrame:CGRectMake(
                                                                    CGRectGetMidX(self.view.frame) - 20.0f, CGRectGetMaxY(self.view.frame) * 0.925, 40.0f, 40.0f)];
    [closeSettingsButton setBackgroundImage:[UIImage imageNamed:@"close_button"]
                                   forState:UIControlStateNormal];
    closeSettingsButton.alpha = 0.0;
    [closeSettingsButton addTarget:self action:@selector(closeSettings) forControlEvents:UIControlEventTouchUpInside];
    darkenView = [[UIView alloc]initWithFrame:self.tableView.frame];
    darkenView.backgroundColor = [UIColor blackColor];
    darkenView.alpha = 0.0;
    [self.view.window addSubview:darkenView];
    [darkenView addSubview:closeSettingsButton];
    [self.view.window addSubview:settingsPane];
    [self fadeInSettings];
}

-(void)closeSettings {
    [UIView animateWithDuration:0.5 animations:^{
        settingsPane.alpha = 0.0f;
        darkenView.alpha = 0.0f;
        closeSettingsButton.alpha = 0.0f;
        settingsIcon.alpha = 0.80f;
    } completion:^(BOOL finished) {
        [settingsPane removeFromSuperview];
        [closeSettingsButton removeFromSuperview];
        [darkenView removeFromSuperview];
        [self.tableView setScrollEnabled:YES];
    }];
}

-(void)fadeInSettings {
    [UIView animateWithDuration:0.5 animations:^{
        [settingsPane setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
        [self.view bringSubviewToFront:settingsPane];
        settingsIcon.alpha = 0.0;
        darkenView.alpha = 0.8;
        settingsPane.alpha = 1.0;
        closeSettingsButton.alpha = 1.0;
    }];
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(NSUInteger)checkColorIndex {
    colorIndex += 1;
    if (colorIndex == 4) {
        colorIndex = -1;
        return 4;
    }
    return colorIndex;
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    YCCellTableViewCell *selectedCell = (YCCellTableViewCell *)[tableView
                                                                cellForRowAtIndexPath:indexPath];
    highlightedCellColor = selectedCell.backgroundColor;
    selectedCell.backgroundColor = [UIColor colorWithRed:40/255.0f green:40/255.0f
                                                    blue:40/255.0f alpha:1.0];
    
    if (selectedCell.backgroundColor == [UIColor yayYellow]) {
        selectedCell.titleLabel.textColor = [UIColor whiteColor];
    } else {
        selectedCell.titleLabel.textColor = [UIColor colorWithWhite:.8 alpha:1.0];
    }
    
}

-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    YCCellTableViewCell *unSelectedCell = (YCCellTableViewCell *)[tableView
                                                                cellForRowAtIndexPath:indexPath];
    
    if ([highlightedCellColor isEqual:[UIColor yayYellow]]) {
        unSelectedCell.titleLabel.textColor = [UIColor blackColor];
    } else {
        unSelectedCell.titleLabel.textColor = [UIColor whiteColor];
    }
    unSelectedCell.backgroundColor = highlightedCellColor;
}



#pragma scrollview methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self adjustSettingsViewOffest];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                       change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        [self adjustSettingsViewOffest];
    }
}

-(void)adjustSettingsViewOffest {
    CGRect updateFrame = settingsIcon.frame;
    updateFrame.origin.x = self.view.bounds.size.width * .85;
    updateFrame.origin.y = self.tableView.contentOffset.y + (self.view.bounds.size.height * .98) - CGRectGetHeight(settingsIcon.bounds);
    settingsIcon.frame = updateFrame;
    [self.tableView bringSubviewToFront:settingsIcon];
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

#pragma mark - Refresh Control

- (IBAction)refresh:(id)sender {
    [api fetchArticles:self.tableView];
    [sender endRefreshing];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"webViewSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        YCCellTableViewCell *cell = sender;
        UINavigationController *navigationController = segue.destinationViewController;
        YCReaderViewController *dvc = (YCReaderViewController *)navigationController.topViewController;
        dvc.barColor = cell.backgroundColor;
        dvc.articleUrl = [[api.articles objectAtIndex:indexPath.row] valueForKey:@"article_link"];
        dvc.sourceText = [[api.articles objectAtIndex:indexPath.row] valueForKey:@"source"];
    }
}


@end
