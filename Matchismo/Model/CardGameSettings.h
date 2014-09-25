//
//  CardGameSettings.h
//  Matchismo
//
//  Created by Konstantin Snegov on 13/08/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardGameSettings : NSObject

@property (nonatomic) NSInteger missmatchPenalty;
@property (nonatomic) NSInteger matchBonus;
@property (nonatomic) NSInteger flipCost;

- (NSDictionary *)plist;
- (instancetype)initWithPlist:(NSDictionary *)plist;

@end
