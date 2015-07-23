//
//  YCSettingsView.m
//  YayComedy
//
//  Created by Jim Joyce on 7/13/15.
//  Copyright (c) 2015 Yay Comedy. All rights reserved.
//

#import "YCSettingsView.h"
#import "YCCellTableViewCell.h"

@interface YCSettingsView() <UITableViewDataSource, UITableViewDelegate> {
    NSArray *cellTitles;
}

@end

@implementation YCSettingsView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 25.0f;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithRed:4.0f/255.0f green:22.0f/255.0f blue:32.0f/255.0f alpha:1.0f];
        self.alpha = 0.0;
        cellTitles = @[@"Privacy Policy",
                       @"Terms of service",
                       @"Twitter",
                       @"Instagram"];
        [self setTransform:CGAffineTransformMakeScale(0.0f, 0.0f)];
        [self addTableViewForSettings:frame];
    }
    return self;
}

-(void)addTableViewForSettings:(CGRect)frame {
    frame.origin.x = 0.0;
    frame.origin.y = 0.0;
    self.tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor grayColor];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setScrollEnabled:NO];
    [self addSubview:self.tableView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cellTitles.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCCellTableViewCell *cell = [[YCCellTableViewCell alloc]init];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"LoveloBlack" size:25.0f];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.textLabel.text = [cellTitles objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    YCCellTableViewCell *selectedCell = (YCCellTableViewCell *)[self.tableView
                                                                cellForRowAtIndexPath:indexPath];
    selectedCell.backgroundColor = [UIColor blackColor];
    selectedCell.textLabel.textColor = [UIColor colorWithWhite:.8 alpha:1.0];
    [self parseUserSelection:indexPath.row];
}

-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    YCCellTableViewCell *selectedCell = (YCCellTableViewCell *)[self.tableView
                                                                cellForRowAtIndexPath:indexPath];
    selectedCell.backgroundColor = [UIColor clearColor];
    selectedCell.textLabel.textColor = [UIColor whiteColor];
}


-(void)parseUserSelection:(NSUInteger)cellIndex {
    switch (cellIndex) {
        case 0:
            //privacy
            NSLog(@"privacy");
            break;
        case 1:
            NSLog(@"terms");
            //terms
            break;
        case 2:
            if ([[UIApplication sharedApplication] canOpenURL:
                 [NSURL URLWithString:@"twitter://user?screen_name=goyaycomedy"]])
            {
                [[UIApplication sharedApplication] openURL:
                 [NSURL URLWithString: @"twitter://user?screen_name=goyaycomedy"]];
                
            } else
            {
                [[UIApplication sharedApplication] openURL:
                 [NSURL URLWithString: @"https://twitter.com/goyaycomedy"]];
            };
            break;
        case 3:
            if ([[UIApplication sharedApplication] canOpenURL:
                 [NSURL URLWithString:@"instagram://user?username=goyaycomedy"]])
            {
                [[UIApplication sharedApplication] openURL:
                 [NSURL URLWithString: @"instagram://user?username=goyaycomedy"]];
                
            } else
            {
                [[UIApplication sharedApplication] openURL:
                 [NSURL URLWithString: @"https://instagram.com/goyaycomedy"]];
            };
            break;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
