//
//  SetDeck.m
//  Matchismo
//
//  Created by Konstantin Snegov on 28/07/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "SetDeck.h"
#import "SetCard.h"

@implementation SetDeck

- (instancetype)init {
    self = [super init];
    if (self) {
        for (NSUInteger number = [SetCard minNumber]; number <= [SetCard maxNumber]; number ++) {
            for (NSString *symbol in [SetCard validSymbol]) {
                for (NSString *shade in [SetCard validShade]) {
                    for (NSString *color in [SetCard validColor]) {
                        SetCard *card = [[SetCard alloc] init];
                        card.number = number;
                        card.symbol = symbol;
                        card.shade = shade;
                        card.color = color;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    return self;
}


@end
