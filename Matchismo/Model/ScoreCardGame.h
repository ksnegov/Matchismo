//
//  ScoreCardGame.h
//  Matchismo
//
//  Created by Konstantin Snegov on 02/08/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardGameType.h"

@protocol ScoreCardGameDelegate <NSObject>
-(void)saveScore;
@end

@interface ScoreCardGame : NSObject

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) CardGameType type;
@property (strong, nonatomic, readonly) NSDate *date;
@property (weak, nonatomic) id<ScoreCardGameDelegate> delegate;

+ (ScoreCardGame *)scoreWithPlist:(NSDictionary *)plist;

- (instancetype)initWithCardGameType:(CardGameType)type;
- (void)increaseScoreBy:(NSInteger)increment;
- (NSDictionary *)plist;

@end
