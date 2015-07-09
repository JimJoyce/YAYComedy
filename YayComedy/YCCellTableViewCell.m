//
//  YCCellTableViewCell.m
//  YayComedy
//
//  Created by Jim Joyce on 7/3/15.
//  Copyright (c) 2015 Yay Comedy. All rights reserved.
//

#import "YCCellTableViewCell.h"
#import "UIColor+Colors.h"

@interface YCCellTableViewCell() {
    NSArray *colors;
}

@end

@implementation YCCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
    colors = @[[UIColor yayLightRed],
               [UIColor yayLightBlue],
               [UIColor yayDarkBlue],
               [UIColor yayYellow],
               [UIColor yayTurquoise]];

    self.titleLabel.font = [UIFont fontWithName:@"LoveloBlack" size:18];
    self.sourceLabel.font = [UIFont fontWithName:@"LoveloBlack" size:12];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCell:(NSUInteger)colorIndex withJson:(NSDictionary *)articleObject{
    [self setColor:colorIndex];
    NSString *sourceString = [NSString stringWithFormat:@"via: %@",
                              [articleObject valueForKey:@"source"]];
    NSString *string = [[articleObject valueForKey:@"title"]
                        stringByReplacingPercentEscapesUsingEncoding:NSUTF16StringEncoding];
    self.titleLabel.text = string;
    self.sourceLabel.text = sourceString;
}

-(void)setColor:(NSUInteger)colorIndex {
    self.backgroundColor = [colors objectAtIndex:colorIndex];
    if (self.backgroundColor == [colors objectAtIndex:3]) {
        self.titleLabel.textColor = [UIColor blackColor];
        self.sourceLabel.textColor = [UIColor blackColor];
    } else {
        self.titleLabel.textColor = [UIColor whiteColor];
        self.sourceLabel.textColor = [UIColor whiteColor];
    }
}

@end
