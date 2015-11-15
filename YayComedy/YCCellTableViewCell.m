//
//  YCCellTableViewCell.m
//  YayComedy
//
//  Created by Jim Joyce on 7/3/15.
//  Copyright (c) 2015 Yay Comedy. All rights reserved.
//

#import "YCCellTableViewCell.h"
#import "YCListViewController.h"
#import "UIColor+Colors.h"
#import "YCApi.h"
#import "NSString+HTML.h"

@interface YCCellTableViewCell() {
    NSArray *colors;
    CFBooleanRef alreadyVoted;
}

@end

@implementation YCCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    colors = @[[UIColor yayLightRed],
               [UIColor yayLightBlue],
               [UIColor yayDarkRed],
               [UIColor yayYellow],
               [UIColor yayPurple],
               [UIColor yayTurquoise]];

    self.titleLabel.font = [UIFont fontWithName:@"LoveloBlack" size:18];
    self.sourceLabel.font = [UIFont fontWithName:@"LoveloBlack" size:12];
    self.scoreLabel.font = [UIFont fontWithName:@"LoveloBlack" size:18];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)configureCell:(NSInteger)colorIndex withJson:(NSDictionary *)articleObject arrayPos:(NSUInteger)pos {
  // NEED TO MAKE THE NEW VOTE RESPONSE CHANGE THE SOURCE ARRAY
  if (self.cellColorIndex == nil) {
      self.cellColorIndex = [NSNumber numberWithInteger:colorIndex];
  }
  self.arrayIndex = pos;
  [self configureVariables:articleObject];
  [self setColor];
  
  [self setLabels:articleObject];
}

-(void)setLabels:(NSDictionary *)articleObject {
  self.titleLabel.text = [[articleObject valueForKey:@"title"] stringByDecodingHTMLEntities];
  self.sourceLabel.text = [NSString stringWithFormat:@"via: %@",
                           [articleObject valueForKey:@"source"]];
  self.scoreLabel.text = [NSString stringWithFormat:@"%@", [articleObject valueForKey:@"score"]];
  self.voteButton.titleLabel.textColor = [self setVoteTextColor:(__bridge CFBooleanRef)([articleObject objectForKey:@"did_vote"])];
}

-(void)configureVariables:(NSDictionary *)articleObject {
  self.artId = [articleObject valueForKey:@"id"];
  self.voteId = (NSNumber *)articleObject[@"vote_id"];
  self.score = [articleObject[@"score"] intValue];
  self.isCurrentlyUpvoted = [articleObject[@"is_active"] boolValue];
  [self changeFlagIfNotVoted];
}

-(void)changeFlagIfNotVoted {
  if ([self.voteId isEqualToNumber:@0]) {
    self.isCurrentlyUpvoted = NO;
    return;
  }
}

-(UIColor *)setVoteTextColor:(CFBooleanRef)didVote {
    if (didVote == kCFBooleanTrue) {
        return [UIColor whiteColor];
    }
    return [UIColor redColor];
}

-(void)setColor{
    self.backgroundColor = [colors objectAtIndex:[self.cellColorIndex intValue]];
    if ([self.backgroundColor isEqual:[UIColor yayYellow]]) {
        self.titleLabel.textColor = [UIColor blackColor];
        self.sourceLabel.textColor = [UIColor blackColor];
        self.scoreLabel.textColor = [UIColor blackColor];
    } else {
        self.scoreLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.sourceLabel.textColor = [UIColor whiteColor];
    }
}

- (IBAction)voteTapped:(id)sender {
  if ([[YCApi sharedInstance] didLogin]) {
    [self sendVote:[YCApi sharedInstance]];
    [self adjustScoreCounter];
    return;
  }
  YCListViewController *rootView = (YCListViewController *)self.window.rootViewController;
  [rootView performSegueWithIdentifier:@"loginSegue" sender:self];
}

-(void)sendVote:(YCApi *)api {
  [api castVote:[self voteParams] fromCell:self successBlock:^(BOOL requestFinished) {
    if (requestFinished) {
      [self updateScoreText:self.score];
    }
  }];
}


-(NSMutableDictionary *)voteParams {
  return [NSMutableDictionary dictionaryWithDictionary:@{@"article_id" : self.artId,
                                                         @"vote_id" : self.voteId,
                                                         @"active" : [NSNumber numberWithBool:self.isCurrentlyUpvoted]}];
}

-(void)adjustScoreCounter {
  if (self.isCurrentlyUpvoted) {
    self.score -= 1; self.isCurrentlyUpvoted = NO;
    return;
  }
  self.score += 1; self.isCurrentlyUpvoted = YES;
}


/*
-(void)sendUpvoteRequest:(YCApi *)api {
  [api upvoteArticle:self withArticleId:self.artId successBlock:^(BOOL requestDone) {
    if (requestDone) {
      [self updateScoreText:self.score];
    }
  }];
}

-(void)sendDownvoteRequest:(YCApi *)api {
  [api downvoteArticle:self withArticleId:self.artId successBlock:^(BOOL requestDone) {
    if (requestDone) {
      [self updateScoreText:self.score];
    }
  }];
}
*/
-(void)updateScoreText:(int)newScore {
  self.scoreLabel.text = [NSString stringWithFormat:@"%i", newScore];
}

-(void)voteVerified {
  //
}

-(void)voteError {
  //
}

@end
