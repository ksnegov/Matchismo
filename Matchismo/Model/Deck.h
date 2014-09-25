//
//  Deck.h
//  Matchismo
//
//  Created by Konstantin Snegov on 29/06/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Card;

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;
- (Card *)drawRandomCard;
- (NSUInteger)cardsCount;

@end
