//
//  CardView.m
//  Matchismo
//
//  Created by Konstantin Snegov on 01/09/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "CardView.h"

@implementation CardView

static float const CardViewCornerRadius = 7.0;

#pragma mark - Setters

- (void)setFaceUp:(BOOL)faceUp {
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (void)setMatched:(BOOL)matched {
    _matched = matched;
    [self setNeedsDisplay];
}

#pragma mark - Initializer

- (void)setup {
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void)awakeFromNib {
    [self setup];
}

#pragma mark - Drawing helpers

- (CGFloat)cornerScaleFactor {
    return 1.0;
}

- (CGFloat)cornerRadius {
    return CardViewCornerRadius * [self cornerScaleFactor];
}

#pragma mark - Abstract

- (void)drawCardInPath:(UIBezierPath *)path {
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    
    if (self.matched) {
        UIColor *color = [UIColor whiteColor];
        color = [color colorWithAlphaComponent:0.5f];
        [color setFill];
    } else {
        [[UIColor whiteColor] setFill];
    }
    
    [[UIColor blackColor] setStroke];
    [roundedRect fill];
    [roundedRect stroke];

    [self drawCardInPath:roundedRect];
}

@end