//
//  CardViewContainer.h
//  Matchismo
//
//  Created by Konstantin Snegov on 15/09/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardView;

@interface CardViewContainer : UIView

@property (nonatomic) CGSize cardSize;
@property (strong, nonatomic) NSMutableArray *cardViews;
@property (nonatomic, readonly) BOOL isCardCombined;

- (void)addCardSubview:(CardView *)view;
- (void)removeCardSubviewAtIndex:(NSUInteger)index;
- (void)removeCardSubview:(CardView *)cardView;
- (void)clearView;
- (CGRect)rectForTheFirstCard;
- (BOOL)canAddViews:(NSUInteger)count;
- (void)separateCards;

@end
