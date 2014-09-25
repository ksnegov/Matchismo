//
//  GameViewController.h
//  Matchismo
//
//  Created by Konstantin Snegov on 28/07/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"
#import "CardGameType.h"

@class Deck;
@class Card;
@class CardView;

@interface GameViewController : UIViewController

@property (strong, nonatomic, readonly) CardMatchingGame *game;


- (CardMatchingGame *)newGameWithCardCount:(NSUInteger)cardCount andGameType:(CardGameType)type;
- (void)updateUI;

//Abstract
- (Deck *)createDeck;
- (NSUInteger)chosenCardsCount;
- (NSUInteger)cardsCount;
- (NSUInteger)shownCardsCount;
- (CardGameType)gameType;
- (void)setCardView:(CardView *)view withCard:(Card *)card;
- (CardView *)cardView;
- (CGSize)cardSize;
- (BOOL)shouldDeleteMatchedCards;

@end
