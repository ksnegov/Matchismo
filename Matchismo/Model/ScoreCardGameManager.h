//
//  ScoreCardGameManager.h
//  Matchismo
//
//  Created by Konstantin Snegov on 02/08/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ScoreCardGame;

@interface ScoreCardGameManager : NSObject

+ (instancetype)sharedManager;

- (void)addScore:(ScoreCardGame *)score;
- (NSArray *)scores;
- (void)synchronize;

@end
