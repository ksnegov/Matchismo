//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Konstantin Snegov on 28/07/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetDeck.h"
#import "SetCard.h"
#import "SetCardView.h"

@implementation SetGameViewController

#pragma mark - Abstract

- (Deck *)createDeck {
    return [[SetDeck alloc] init];
}

- (NSUInteger)chosenCardsCount {
    return 3;
}

- (NSUInteger)cardsCount {
    return [[self createDeck] cardsCount];
}

- (NSUInteger)shownCardsCount {
    return 12;
}

- (CardGameType)gameType {
    return CardGameTypeSet;
}

- (CardView *)cardView {
    return [[SetCardView alloc] init];
}

- (CGSize)cardSize {
    return CGSizeMake(50, 70);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

- (BOOL)shouldDeleteMatchedCards {
    return YES;
}

- (void)setCardView:(CardView *)view withCard:(Card *)card {
    SetCardView *setCardView = (SetCardView *)view;
    SetCard *setCard = (SetCard *)card;
    
        [UIView transitionWithView:view duration:0.5f options:UIViewAnimationOptionTransitionNone animations:^{
            setCardView.faceUp = setCard.isChosen;
            setCardView.matched = setCard.isMatched;

            setCardView.number = setCard.number;

            if ([setCard.symbol isEqualToString:@"diamond"]) {
                setCardView.shape = SetCardViewShapeDiamond;
            } else if ([setCard.symbol isEqualToString:@"oval"]) {
                setCardView.shape = SetCardViewShapeOval;
            } else {
                setCardView.shape = SetCardViewShapeSquiggle;
            }

            if ([setCard.shade isEqualToString:@"solid"]) {
                setCardView.shade = SetCardViewShadeSolid;
            } else if ([setCard.shade isEqualToString:@"striped"]) {
                setCardView.shade = SetCardViewShadeStriped;
            } else {
                setCardView.shade = SetCardViewShadeOpen;
            }
            
            if ([setCard.color isEqualToString:@"red"]) {
                setCardView.color = [UIColor redColor];
            } else if ([setCard.color isEqualToString:@"green"]) {
                setCardView.color = [UIColor greenColor];
            } else {
                setCardView.color = [UIColor purpleColor];
            }
            
        }completion:^(BOOL success){
        }];
}


@end