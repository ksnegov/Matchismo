//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Konstantin Snegov on 10/07/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "CardMatchingGame.h"
#import "ScoreCardGame.h"
#import "ScoreCardGameManager.h"
#import "Deck.h"
#import "Card.h"
#import "CardGameSettings.h"
#import "CardGameSettingsStore.h"

@interface CardMatchingGame() <ScoreCardGameDelegate>
@property (nonatomic, strong) ScoreCardGame *gameScore;
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic) NSUInteger cardCount;
@property (nonatomic, readwrite, getter = hasStarted) BOOL started;
@property (nonatomic, readwrite) NSInteger flipScore;
@property (strong, readwrite) NSArray *chosenCards;
@property (nonatomic) CardGameType type;
@property (strong, nonatomic) CardGameSettings *settings;
@property (nonatomic) BOOL shouldDeleteMatchedCards;
@end

@implementation CardMatchingGame

- (CardGameSettings *)settings {
    if (!_settings) {
        _settings = [[CardGameSettingsStore sharedStore] cardGameSettings];
    }
    return _settings;
}

- (void)saveScore {
    [[ScoreCardGameManager sharedManager] synchronize];
}

- (NSUInteger)cardCountForMatch {
    return self.cardCount + 1;
}

- (NSInteger)score {
    return self.gameScore.score;
}

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (ScoreCardGame *)gameScore {
    if (!_gameScore) {
        _gameScore = [[ScoreCardGame alloc] initWithCardGameType:self.type];
        _gameScore.delegate = self;
        [[ScoreCardGameManager sharedManager] addScore:_gameScore];
    }
    return _gameScore;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck {
    return [self initWithCardCount:count usingDeck:deck cardCountForMatch:2 andGameType:CardGameTypeCard];
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck  cardCountForMatch:(NSUInteger)cardCountForMatch andGameType:(CardGameType)type{
    return [self initWithCardCount:count usingDeck:deck cardCountForMatch:cardCountForMatch andGameType:type deleteMatchedCards:NO];
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck cardCountForMatch:(NSUInteger)cardCountForMatch andGameType:(CardGameType)type deleteMatchedCards:(BOOL)shouldDeleteMatchedCards {
    self = [super init];
    if (self) {
        _started = NO;
        _shouldDeleteMatchedCards = shouldDeleteMatchedCards;
        if (cardCountForMatch < 2) return nil;
        _cardCount = cardCountForMatch - 1;
        _type = type;
        
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    return self;
    
}

- (void)chooseCardAtIndex:(NSUInteger)index {
    self.started = YES;
    NSInteger chooseScore = 0;

    NSMutableArray *otherCards = [[NSMutableArray alloc] init];
    
    Card *card = [self cardAtIndex:index];
    if (card.isMatched) return;
    
    if (card.isChosen) {
        card.chosen = NO;

        for (Card *otherCard in self.cards) {
            if (otherCard.isChosen && !otherCard.isMatched) {
                [otherCards addObject:otherCard];
                if ([otherCards count] == self.cardCount)
                    break;
            }
        }

    } else {
        for (Card *otherCard in self.cards) {
            if (otherCard.isChosen && !otherCard.isMatched) {
                [otherCards addObject:otherCard];
                if ([otherCards count] == self.cardCount)
                    break;
            }
        }

        if ([otherCards count] == self.cardCount) {
            int matchedScore = [card match:[otherCards copy]];
            if (matchedScore) {
                chooseScore += matchedScore * self.settings.matchBonus * [otherCards count];
                for (Card *otherCard in otherCards) {
                    otherCard.matched = YES;
                }
                card.matched = YES;
            } else {
                chooseScore -= self.settings.missmatchPenalty;
                for (Card *otherCard in otherCards) {
                    otherCard.chosen = NO;
                }
            }
        }
        chooseScore -= self.settings.flipCost;
        [self.gameScore increaseScoreBy:chooseScore];
        self.flipScore = chooseScore;
        card.chosen = YES;
        [otherCards addObject:card];
    }
    
    self.chosenCards = [otherCards copy];
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return ([self.cards count] > index) ? self.cards[index] : nil;
}

- (NSUInteger)indexForCard:(Card *)card {
    return [self.cards indexOfObject:card];
}

- (NSArray *)cardsInGame {
    NSMutableArray *cardsInGame = [[NSMutableArray alloc] init];
    for (Card *card in self.cards) {
        if (!card.isMatched) {
            [cardsInGame addObject:card];
        }
    }
    return [cardsInGame copy];
}

- (void)removeCard:(Card *)card {
    [self.cards removeObject:card];
}

- (void)removeCardAtIndex:(NSUInteger)index {
    if ([self.cards count] > index)
        [self.cards removeObjectAtIndex:index];
}

@end
