//
//  YCCellTableViewCell.m
//  YayComedy
//
//  Created by Jim Joyce on 7/3/15.
//  Copyright (c) 2015 Yay Comedy. All rights reserved.
//

#import "YCCellTableViewCell.h"

@interface YCCellTableViewCell() {
    NSArray *colors;
}

@end

@implementation YCCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
    colors = @[[UIColor colorWithRed:233.0f/255.0f green:101.0f/255.0f blue:99.0f/255.0f alpha:1.0f],
               [UIColor colorWithRed:46.0f/255.0f green:162.0f/255.0f blue:211.0f/255.0f alpha:1.0f],
               [UIColor colorWithRed:254.0f/255.0f green:241.0f/255.0f blue:1.0f/255.0f alpha:1.0f],
               [UIColor colorWithRed:4.0f/255.0f green:22.0f/255.0f blue:32.0f/255.0f alpha:1.0f],
               [UIColor colorWithRed:65.0f/255.0f green:148.0f/255.0f blue:144.0f/255.0f alpha:1.0f]];
    
    self.backgroundColor = [colors objectAtIndex: (arc4random() % 4)];
    self.textLabel.textColor = [UIColor whiteColor];
//    self.titleLabel.font = [UIFont fontWithName:@"LoveloBlack" size:18];
//    self.dateLabel.font = [UIFont fontWithName:@"LoveloBlack" size:10];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCell:(NSUInteger)object{
//    self.textLabel.text = ;
}

@end
