//
//  YCLoadingView.h
//  YayComedy
//
//  Created by Jim Joyce on 11/4/15.
//  Copyright © 2015 Yay Comedy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCLoadingView : UIImageView
+(YCLoadingView *)sharedInstance;
-(void)removeFromContext;
-(void)fadeOutWithDuration:(NSTimeInterval)duration;
-(id)init;
@end
