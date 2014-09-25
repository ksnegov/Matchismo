//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Konstantin Snegov on 29/06/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingDeck.h"
#import "PlayingCard.h"
#import "PlayingCardView.h"

@interface CardGameViewController ()
@end

@implementation CardGameViewController

- (NSUInteger)chosenCardsCount {
    return 2;
}

- (NSUInteger)cardsCount {
    return 20;
}

- (NSUInteger)shownCardsCount {
    return [self cardsCount];
}

- (CardGameType)gameType {
    return CardGameTypeCard;
}

- (Deck *)createDeck {
    return [[PlayingDeck alloc] init];
}

- (CardView *)cardView {
    return [[PlayingCardView alloc] init];
}

- (CGSize)cardSize {
    return CGSizeMake(50, 70);
}

- (void)setCardView:(CardView *)view withCard:(Card *)card {
    PlayingCardView *playingCardView = (PlayingCardView *)view;
    PlayingCard *playingCard = (PlayingCard *)card;
    
    if (view.faceUp != playingCard.isChosen) {
        [UIView transitionWithView:view duration:0.5f options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            playingCardView.faceUp = playingCard.isChosen;
            playingCardView.matched = playingCard.isMatched;
            playingCardView.suit = playingCard.suit;
            playingCardView.rank = playingCard.rank;

        }completion:^(BOOL success){
        }];
    } else {
        playingCardView.matched = playingCard.isMatched;        
    }
}

@end
