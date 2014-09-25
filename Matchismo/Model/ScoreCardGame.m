//
//  ScoreCardGame.m
//  Matchismo
//
//  Created by Konstantin Snegov on 02/08/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "ScoreCardGame.h"

@interface ScoreCardGame()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) CardGameType type;
@property (strong, nonatomic, readwrite) NSDate *date;

@end

@implementation ScoreCardGame

static NSString * const ScoreCardGamePlistScore = @"score";
static NSString * const  ScoreCardGamePlistType = @"type";
static NSString * const  ScoreCardGamePlistDate = @"date";

#pragma mark - Plist 

- (NSDictionary *)plist {
    return @{ ScoreCardGamePlistScore : [NSNumber numberWithInteger:self.score],
              ScoreCardGamePlistType  : [NSNumber numberWithInteger:self.type],
              ScoreCardGamePlistDate  : self.date
            };
}

+ (ScoreCardGame *)scoreWithPlist:(NSDictionary *)plist {
    NSNumber *score = plist[ScoreCardGamePlistScore];
    NSNumber *type = plist[ScoreCardGamePlistType];
    NSDate *date = plist[ScoreCardGamePlistDate];
    ScoreCardGame *gameScore = [[ScoreCardGame alloc] initWithCardGameType:[type integerValue] andScore:[score integerValue] andDate:date];
    return gameScore;
}

#pragma mark - Initializers

- (instancetype)init {
    return nil;
}

- (instancetype)initWithCardGameType:(CardGameType)type andScore:(NSInteger)score andDate:(NSDate *)date {
    self = [super init];
    if (self) {
        _type = type;
        _score = score;
        _date = date;
    }
    return self;
}

- (instancetype)initWithCardGameType:(CardGameType)type {
    self = [self initWithCardGameType:type andScore:0 andDate:[NSDate date]];
    return self;
}

#pragma mark - Score

- (void)increaseScoreBy:(NSInteger)increment {
    self.score += increment;
    [self.delegate saveScore];
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ game: %li started at: %@", self.type == CardGameTypeCard ? @"Card" : @"Set", (long)self.score, self.date];
}

@end
