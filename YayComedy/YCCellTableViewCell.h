//
//  YCCellTableViewCell.h
//  YayComedy
//
//  Created by Jim Joyce on 7/3/15.
//  Copyright (c) 2015 Yay Comedy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property NSNumber *cellColorIndex;
@property(strong, nonatomic) NSString *isUpvoted;
@property (strong, nonatomic)NSNumber *artId;
@property (strong, nonatomic)NSNumber *voteId;
@property NSUInteger arrayIndex;
@property int score;
@property BOOL configDone;
@property BOOL isCurrentlyUpvoted;
@property (weak, nonatomic) IBOutlet UIButton *voteButton;

@property(strong, nonatomic)NSString *title;
@property(strong, nonatomic)NSString *date;
@property(strong, nonatomic)NSString *articleUrl;
@property(strong, nonatomic)NSString *source;
-(void)configureCell:(NSInteger)colorIndex withJson:(NSDictionary *)articleObject arrayPos:(NSUInteger)pos;

@end
