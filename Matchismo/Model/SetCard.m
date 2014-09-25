//
//  SetCard.m
//  Matchismo
//
//  Created by Konstantin Snegov on 28/07/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

const static NSUInteger SetCardMinNumber = 1;
const static NSUInteger SetCardMaxNumber = 3;

+ (NSArray *)validSymbol {
    return @[ @"diamond", @"squiggle", @"oval" ];
}

+ (NSArray *)validShade {
    return @[ @"solid", @"striped", @"open" ];
}

+ (NSArray *)validColor {
    return @[ @"red", @"green", @"purple" ];
}

+ (NSUInteger)minNumber {
    return SetCardMinNumber;
}

+ (NSUInteger)maxNumber {
    return SetCardMaxNumber;
}

#pragma mark - Setters

- (void)setNumber:(NSUInteger)number {
    _number = (number >= SetCardMinNumber && number <= SetCardMaxNumber) ? number : SetCardMinNumber;
}

- (void)setSymbol:(NSString *)symbol {
    if ([[[self class] validSymbol] containsObject:symbol]) {
        _symbol = symbol;
    }
}

- (void)setShade:(NSString *)shade {
    if ([[[self class] validShade] containsObject:shade]) {
        _shade = shade;
    }
}

- (void)setColor:(NSString *)color {
    if ([[[self class] validColor] containsObject:color]) {
        _color = color;
    }
}

#pragma mark - Description

- (NSString *)description {
    return [self contents];
}

- (NSString *)contents {
    return [NSString stringWithFormat:@"%@", [self symbols]];
}

- (NSString *)symbols {
    NSString *numberOfSymbols = @"";
    NSString *symbolShape;
    if ([self.symbol isEqualToString:@"diamond"]) {
        symbolShape = @"♢";
    } else if ([self.symbol isEqualToString:@"squiggle"]) {
        symbolShape = @"▢";
    } else if ([self.symbol isEqualToString:@"oval"]) {
        symbolShape = @"◯";
    }
    
    for (int i = SetCardMinNumber; i <= self.number; i++) {
        numberOfSymbols = [NSString stringWithFormat:@"%@%@", numberOfSymbols, symbolShape];
    }
    return numberOfSymbols;
}



#pragma mark - Match

- (int)match:(NSArray *)otherCards {
    int score = 0;
    if ([otherCards count] != 2) {
        NSLog(@"Not enough cards passed");
        return score;
    }
    
    NSMutableSet *cardValues = [[NSMutableSet alloc] init];
    
    for (SetCard *otherCard in otherCards) {
        [cardValues addObject:[NSNumber numberWithUnsignedInteger:otherCard.number]];
    }
    if ([cardValues count] == 3 || [cardValues count] == 1) {
        score = 3;
        return score;
    }

    [cardValues removeAllObjects];
    for (SetCard *otherCard in otherCards) {
        [cardValues addObject:otherCard.symbol];
    }
    if ([cardValues count] == 3 || [cardValues count] == 1) {
        score = 3;
        return score;
    }

    [cardValues removeAllObjects];
    for (SetCard *otherCard in otherCards) {
        [cardValues addObject:otherCard.shade];
    }
    if ([cardValues count] == 3 || [cardValues count] == 1) {
        score = 3;
        return score;
    }

    [cardValues removeAllObjects];
    for (SetCard *otherCard in otherCards) {
        [cardValues addObject:otherCard.color];
    }
    if ([cardValues count] == 3 || [cardValues count] == 1) {
        score = 3;
        return score;
    }
    
    return score;

}

@end
