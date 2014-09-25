//
//  GameViewController.m
//  Matchismo
//
//  Created by Konstantin Snegov on 28/07/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "GameViewController.h"
#import "HistoryViewController.h"
#import "Card.h"
#import "CardView.h"
#import "CardViewContainer.h"

@interface GameViewController () <UIAlertViewDelegate>
@property (strong, nonatomic, readwrite) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet CardViewContainer *cardsContainerView;
@end

@implementation GameViewController

#pragma mark - Game

- (CardMatchingGame *)newGameWithCardCount:(NSUInteger)cardCount andGameType:(CardGameType)type {
    return [[CardMatchingGame alloc] initWithCardCount:[self cardsCount] usingDeck:[self createDeck] cardCountForMatch:cardCount andGameType:type deleteMatchedCards:self.shouldDeleteMatchedCards];
}

#pragma mark - Abstract

- (Deck *)createDeck {
    return nil;
}

- (CardMatchingGame *)newGame {
    return nil;
}

- (NSUInteger)chosenCardsCount {
    return 0;
}

- (NSUInteger)cardsCount {
    return 0;
}

- (NSUInteger)shownCardsCount {
    return 0;
}

- (CardGameType)gameType {
    return CardGameTypeCard;
}

- (void)setCardView:(CardView *)view withCard:(Card *)card {
}

- (CardView *)cardView {
    return nil;
}

- (CGSize)cardSize {
    return CGSizeZero;
}

- (BOOL)shouldDeleteMatchedCards {
    return NO;
}

#pragma mark - Getters and Setters

- (CardMatchingGame *)game {
    if (!_game) _game = [self newGameWithCardCount:[self chosenCardsCount] andGameType:[self gameType]];
    return _game;
}

#pragma mark - Update UI

- (void)updateUI {
    for (CardView *view in self.cardsContainerView.cardViews) {
        NSUInteger index = [self cardIndexForCardView:view];
        Card *card = [self.game cardAtIndex:index];
        [self setCardView:view withCard:card];
    }
 
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
}

#pragma mark - New game

- (IBAction)deal {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Redeal" message:@"Do you want to redeal?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        self.game = nil;
        [self.cardsContainerView clearView];
        [self createCardViews];
        [self updateUI];
    }
}

- (void)createCardViews {
    for (NSUInteger index = 0; index < [self shownCardsCount]; index++) {
        [self createCardView];
    }
}

- (void)createCardView {
    CardView * view = [self cardView];
    view.frame = [self.cardsContainerView rectForTheFirstCard];
    [self.cardsContainerView addCardSubview:view];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCard:)];
    [view addGestureRecognizer:tapRecognizer];
}

#pragma mark - Viewcontroller lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cardsContainerView.cardSize = [self cardSize];
    [self createCardViews];
}

#pragma mark - Gestures

- (void)chooseCard:(UIGestureRecognizer *)recognizer {
    if (!self.cardsContainerView.isCardCombined) {
        [self.game chooseCardAtIndex:[self.cardsContainerView.cardViews indexOfObject:recognizer.view]];
        if ([self.game.chosenCards count] == [self chosenCardsCount] && self.game.flipScore > 0) {
            if (self.shouldDeleteMatchedCards) {
                for (Card *card in self.game.chosenCards) {
                    NSUInteger viewIndex = [self viewIndexForCard:card];
                    [self.cardsContainerView removeCardSubviewAtIndex:viewIndex];
                    [self.game removeCard:card];
                }
            }
        }
        [self updateUI];
    } else {
        [self.cardsContainerView separateCards];
    }
}

#pragma mark - Index in container

- (NSUInteger)viewIndexForCard:(Card *)card {
    return [self.game indexForCard:card];
}

- (NSUInteger)cardIndexForCardView:(CardView *)cardView {
    return [self.cardsContainerView.cardViews indexOfObject:cardView];
}

#pragma mark - Adding cards on the table

- (IBAction)addCardsOnTheTable:(id)sender {
    if ([self.cardsContainerView canAddViews:[self chosenCardsCount]]) {
        for (NSUInteger index = 0; index < [self chosenCardsCount]; index++) {
            [self createCardView];
        }
        [self updateUI];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No more cards" message:@"You have enough cards to deal with" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

@end
