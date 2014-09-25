//
//  CardGameSettings.m
//  Matchismo
//
//  Created by Konstantin Snegov on 13/08/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "CardGameSettings.h"

@implementation CardGameSettings

static NSString * const CardGameSettingsMissmatchPenalty = @"MissmatchPenalty";
static NSString * const CardGameSettingsMatchBonus = @"MatchBonus";
static NSString * const CardGameSettingsFlipCost = @"FlipCost";

- (instancetype)init {
    return [self initWithPlist:@{ CardGameSettingsMissmatchPenalty : @2,
                                  CardGameSettingsMatchBonus : @4,
                                  CardGameSettingsFlipCost : @1
                                }];
}

- (NSDictionary *)plist {
    return @{ CardGameSettingsMissmatchPenalty : [NSNumber numberWithLong:self.missmatchPenalty],
              CardGameSettingsMatchBonus : [NSNumber numberWithLong:self.matchBonus],
              CardGameSettingsFlipCost : [NSNumber numberWithLong:self.flipCost]
            };
}

- (instancetype)initWithPlist:(NSDictionary *)plist {
    if (!plist) return nil;
    
    self = [super init];
    if (self) {
        NSNumber *missmatch = plist[CardGameSettingsMissmatchPenalty];
        _missmatchPenalty = [missmatch intValue];

        NSNumber *match = plist[CardGameSettingsMatchBonus];
        _matchBonus = [match intValue];
        
        NSNumber *flip = plist[CardGameSettingsFlipCost];
        _flipCost = [flip intValue];
    }
    return self;
}

@end
