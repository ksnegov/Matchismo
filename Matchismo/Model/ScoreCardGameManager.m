//
//  ScoreCardGameManager.m
//  Matchismo
//
//  Created by Konstantin Snegov on 02/08/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "ScoreCardGameManager.h"
#import "ScoreCardGame.h"

@interface ScoreCardGameManager()
@property (nonatomic, strong) NSMutableArray *gameScores;
@end

@implementation ScoreCardGameManager

static NSString * const ScoreCardGameManagerScores = @"scoresWithDates";

+ (instancetype)sharedManager {
    static ScoreCardGameManager *scoreManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scoreManager = [[ScoreCardGameManager alloc] initPrivate];
    });
    return scoreManager;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Wrong initializtion" reason:@"It's singltone, use it" userInfo:nil];
}

- (instancetype)initPrivate {
    self = [super init];
    return self;
}

- (NSMutableArray *)gameScores {
    if (!_gameScores)
    {
        _gameScores = [[NSMutableArray alloc] init];
        
        //load from NSUserDefauls
        NSArray *plists = [[NSUserDefaults standardUserDefaults] objectForKey:ScoreCardGameManagerScores];
        for (NSDictionary *plist in plists) {
            ScoreCardGame *score = [ScoreCardGame scoreWithPlist:plist];
            [_gameScores addObject:score];
        }
    }
    return _gameScores;
}

- (void)addScore:(ScoreCardGame *)score {
    [self.gameScores addObject:score];
    [self synchronize];
}

- (NSArray *)scores {
    return [self.gameScores copy];
}

- (void)synchronize {
    NSMutableArray *plists = [[NSMutableArray alloc] init];
    for (ScoreCardGame *score in self.scores) {
        [plists addObject:[score plist]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:plists forKey:ScoreCardGameManagerScores];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
