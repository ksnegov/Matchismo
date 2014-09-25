//
//  PlayingCard.m
//  Matchismo
//
//  Created by Konstantin Snegov on 29/06/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;

- (NSString *)suit {
    return _suit ? _suit : @"?";
}

- (void)setSuit:(NSString *)suit {
    if ([[[self class] validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (void)setRank:(NSUInteger)rank {
    if (rank <= [[self class] maxRank]) {
        _rank = rank;
    }
}

+ (NSArray *)validSuits {
    return @[@"♥︎", @"♠︎", @"♣︎", @"♦︎"];
}

+ (NSArray *)rankStrings {
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank {
    return [[self rankStrings] count];
}

- (NSString *)contents {
    return [[[self class] rankStrings][self.rank] stringByAppendingString:self.suit];
}

- (int)match:(NSArray *)otherCards {
    int score = 0;
    
    for (PlayingCard *otherCard in otherCards) {
        if (otherCard.rank == self.rank) {
            score += 4;
        } else {
            score = 0;
            break;
        }
    }

    if (score == 0) {
        for (PlayingCard *otherCard in otherCards) {
            if ([otherCard.suit isEqualToString:self.suit]) {
                score += 1;
            } else {
                score = 0;
                break;
            }
        }
    }

    return score;
}

- (NSString *)description {
   return [self contents];
}

@end
