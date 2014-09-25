//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Konstantin Snegov on 10/07/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardGameType.h"

@class Deck;
@class Card;

@interface CardMatchingGame : NSObject

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly, getter = hasStarted) BOOL started;
@property (nonatomic, readonly) NSUInteger cardCountForMatch;
@property (nonatomic, readonly) NSInteger flipScore;
@property (strong, readonly) NSArray *chosenCards;

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck cardCountForMatch:(NSUInteger)cardCountForMatch andGameType:(CardGameType)type deleteMatchedCards:(BOOL)shouldDeleteMatchedCards;
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck cardCountForMatch:(NSUInteger)cardCountForMatch andGameType:(CardGameType)type;
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (NSUInteger)indexForCard:(Card *)card;
- (NSArray *)cardsInGame;
- (void)removeCard:(Card *)card;
- (void)removeCardAtIndex:(NSUInteger)index;

@end
