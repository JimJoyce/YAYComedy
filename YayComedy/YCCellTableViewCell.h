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
@property NSNumber *cellColorIndex;

@property(strong, nonatomic)NSString *title;
@property(strong, nonatomic)NSString *date;
@property(strong, nonatomic)NSString *articleUrl;
@property(strong, nonatomic)NSString *source;
-(void)configureCell:(NSUInteger)colorIndex withJson:(NSDictionary *)articleObject;

@end
