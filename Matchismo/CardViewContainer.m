//
//  CardViewContainer.m
//  Matchismo
//
//  Created by Konstantin Snegov on 15/09/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "CardViewContainer.h"
#import "CardView.h"

@interface CardViewContainer() <UIDynamicAnimatorDelegate>
@property (nonatomic, readwrite) BOOL isCardCombined;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@end

@implementation CardViewContainer

static float const CardViewContainerDefaultSpace = 8.0;

#pragma mark - Getters

- (NSMutableArray *)cardViews {
    if (!_cardViews) _cardViews = [[NSMutableArray alloc] init];
    return _cardViews;
}

- (UIDynamicAnimator *)animator {
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
        _animator.delegate = self;
    }
    return _animator;
}

#pragma mark - Adding / removing subviews

- (void)addCardSubview:(CardView *)view {
    [self.cardViews addObject:view];
    [self addSubview:view];
}

- (void)removeCardSubviewAtIndex:(NSUInteger)index {
    CardView *cardView = [self.cardViews objectAtIndex:index];
    [self removeCardSubview:cardView];
}

- (void)removeCardSubview:(CardView *)cardView {
    [self.cardViews removeObject:cardView];
    [UIView animateWithDuration:0.5 animations:^{
        int x = (arc4random()%(int)(self.bounds.size.width*5)) - (int)self.bounds.size.width*2;
        int y = self.bounds.size.height + cardView.frame.size.height;
        cardView.center = CGPointMake(x, y);
    } completion:^(BOOL finished){
        if (finished) {
            [cardView removeFromSuperview];
        }
    }];
}

- (void)clearView {
    for (UIView *view in self.cardViews) {
        [UIView animateWithDuration:0.5 animations:^{
                int x = (arc4random()%(int)(self.bounds.size.width*5)) - (int)self.bounds.size.width*2;
                int y = self.bounds.size.height + view.frame.size.height;
                view.center = CGPointMake(x, y);
        } completion:^(BOOL finished){
            if (finished) {
                [view removeFromSuperview];
            }
        }];
    }
    [self.cardViews removeAllObjects];
}

- (void)separateCards {
    [self.animator removeAllBehaviors];
    self.isCardCombined = NO;
    [self layoutSubviews];
}

#pragma mark - View lifecycle

- (void)layoutSubviews {
    if (!self.isCardCombined) {
        for (NSUInteger index = 0; index < [self.cardViews count]; index++) {
            CGRect frame = [self rectForCardIndex:index];
            UIView *cardView = [self.cardViews objectAtIndex:index];
            [UIView animateWithDuration:0.5 animations:^{
                [cardView setFrame:frame];
            }completion:^(BOOL finished){
            }];
        }
    }
}

- (void)setup {
    self.isCardCombined = NO;
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [self addGestureRecognizer:pinchGestureRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:panGestureRecognizer];
}

- (void)awakeFromNib {
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

#pragma mark - Coordinates for cards

- (int)cardsInRow {
    return self.frame.size.width / [self cardWidthWithSpaces];
}

- (float)cardWidthWithSpaces {
    return (self.cardSize.width + CardViewContainerDefaultSpace * 2);
}

- (float)cardHeightWithSpaces {
    return (self.cardSize.height + 5 * 2);
}

- (CGRect)rectForCardIndex:(NSUInteger)index {
    int cardsInRow = [self cardsInRow];
    int widthIndex = (index >= cardsInRow) && (cardsInRow != 0) ? index % cardsInRow : (int)index;
    int heightIndex = (index >= cardsInRow) && (cardsInRow != 0) ? (int)index / cardsInRow : 0;
    
    float cardsInRowWidth = (self.cardSize.width + CardViewContainerDefaultSpace * 2) * cardsInRow;
    float freeWidthInRow = self.frame.size.width - cardsInRowWidth;
    float leftSpace = freeWidthInRow / 2; // Calculate left and right spaces from the row
    
    leftSpace += [self cardWidthWithSpaces] * widthIndex;
    
    float topSpace = 25;
    topSpace += [self cardHeightWithSpaces] * heightIndex;
    
    return CGRectMake(leftSpace, topSpace, self.cardSize.width, self.cardSize.height);
}

- (CGRect)rectForTheFirstCard {
    return [self rectForCardIndex:0];
}

- (BOOL)canAddViews:(NSUInteger)count {
    NSInteger maxIndex = [self.cardViews count] - 1;
    maxIndex += count;
    CGRect frame = [self rectForCardIndex:maxIndex];
    return CGRectContainsRect(self.frame, frame);
}

#pragma mark - Gesture recognizers

- (void)pinch:(UIGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (!self.isCardCombined) {
            self.isCardCombined = YES;
            CGPoint location = [recognizer locationInView:self];
            
            for (CardView *view in self.cardViews) {
                UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:view attachedToAnchor:location];
                attachment.length = 0.0;
                [self.animator addBehavior:attachment];
            }
        }
    }
}

- (void)pan:(UIGestureRecognizer *)recognizer {
    if (self.isCardCombined) {
        if (recognizer.state == UIGestureRecognizerStateChanged) {
            CGPoint location = [recognizer locationInView:self];
            for (UIDynamicBehavior *behavior in self.animator.behaviors) {
                if ([behavior isKindOfClass:[UIAttachmentBehavior class]]) {
                    UIAttachmentBehavior *attachment = (UIAttachmentBehavior *)behavior;
                    attachment.anchorPoint = location;
                }
            }
        }
    }
}

@end
