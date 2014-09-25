//
//  CardGameSettingsStore.h
//  Matchismo
//
//  Created by Konstantin Snegov on 16/08/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CardGameSettings;

@interface CardGameSettingsStore : NSObject

+ (instancetype)sharedStore;

- (CardGameSettings *)cardGameSettings;
- (void)saveCardGameSettings:(CardGameSettings *)settings;

@end
