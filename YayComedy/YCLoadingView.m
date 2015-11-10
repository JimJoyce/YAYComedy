//
//  YCLoadingView.m
//  YayComedy
//
//  Created by Jim Joyce on 11/4/15.
//  Copyright © 2015 Yay Comedy. All rights reserved.
//

#import "YCLoadingView.h"

@implementation YCLoadingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(YCLoadingView *)sharedInstance {
  static YCLoadingView *instance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[YCLoadingView alloc]init];
  });
  return instance;
}

-(id)init {
    self = [super initWithImage:[UIImage imageNamed:@"splash.png"]];
  
    if (self) {
      [self setFrame:[[UIScreen mainScreen] bounds]];
      [self setContentMode:UIViewContentModeScaleAspectFill];
      [self setUserInteractionEnabled:NO];
      [self setAlpha:1.0f];
      self.opaque = YES;
    }
    return self;
}


-(void)removeFromContext {
  [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    [self setTransform:CGAffineTransformMakeTranslation(0.0, -self.frame.size.height)];
  } completion:^(BOOL finished) {
    [self removeFromSuperview];
  }];
}

-(void)fadeOutWithDuration:(NSTimeInterval)duration {
  [UIView animateWithDuration:duration animations:^{
    [self setAlpha:0.0];
  } completion:^(BOOL finished) {
    [self removeFromSuperview];
  }];
}

@end
