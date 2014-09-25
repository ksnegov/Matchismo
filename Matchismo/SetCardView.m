//
//  SetCardView.m
//  Matchismo
//
//  Created by Konstantin Snegov on 03/09/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "SetCardView.h"

static int const SetCardViewMaxNumber = 3;
static float const SetCardViewLeftSpace = 5.0f;
static float const SetCardViewLineWidth = 0.5f;
static float const SetCardViewCornerRadius = 4.0f;

@implementation SetCardView

#pragma mark - Setters

- (void)setNumber:(NSUInteger)number {
    _number = number;
    [self setNeedsDisplay];
}

- (void)setShape:(SetCardViewShape)shape {
    _shape = shape;
    [self setNeedsDisplay];
}

- (void)setShade:(SetCardViewShade)shade {
    _shade = shade;
    [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}

#pragma mark - Drawing helpers

- (UIColor *)fillColor {
    UIColor *fillColor = [UIColor whiteColor];
    
    if (self.shade == SetCardViewShadeSolid) {
        fillColor = self.color;
    } else if (self.shade == SetCardViewShadeStriped) {
        fillColor = self.color;
        fillColor = [fillColor colorWithAlphaComponent:0.60f];
    }
    return fillColor;
}

- (UIColor *)strokeColor {
    return self.color;
}

#pragma mark - Drawing

- (void)drawOvalInRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:SetCardViewCornerRadius];
    path.lineWidth = SetCardViewLineWidth;
    
    [[self strokeColor] setStroke];
    [[self fillColor] setFill];
    
    [path fill];
    [path stroke];
}

- (void)drawDiamodInRect:(CGRect)rect {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y)];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height / 2)];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height)];
    [path addLineToPoint:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height / 2)];
    [path closePath];
    
    [[self strokeColor] setStroke];
    [[self fillColor] setFill];
    
    [path fill];
    [path stroke];
}

- (void)drawSquiggleInRect:(CGRect)rect {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    CGFloat dx = rect.size.width / 3;
    CGFloat dx1 = dx / 2;
    CGFloat dx2 = dx1 + dx;
    
    CGFloat scale = rect.size.height / 1.5;
    
    [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height / 3)];
    [path addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y) controlPoint1:CGPointMake(rect.origin.x + dx1, rect.origin.y - scale) controlPoint2:CGPointMake(rect.origin.x + dx2, rect.origin.y + rect.size.height / 3 + scale)];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height / 3 * 2)];
    [path addCurveToPoint:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height) controlPoint1:CGPointMake(rect.origin.x + dx2, rect.origin.y + rect.size.height + scale) controlPoint2:CGPointMake(rect.origin.x + dx1, rect.origin.y + rect.size.height / 3 * 2 - scale)];
    [path closePath];
    
    [[self strokeColor] setStroke];
    [[self fillColor] setFill];
    
    [path fill];
    [path stroke];
}

- (void)drawCardInPath:(UIBezierPath *)path {
    if (self.faceUp) {
        UIColor *color = [UIColor grayColor];
        color = [color colorWithAlphaComponent:0.5f];
        [color setFill];
    } else {
        [[UIColor whiteColor] setFill];
    }
    [path fill];
    
    CGFloat x = SetCardViewLeftSpace;
    CGFloat y;
    CGFloat width = self.bounds.size.width - x - SetCardViewLeftSpace;
    CGFloat height = (self.bounds.size.height / SetCardViewMaxNumber) - (SetCardViewLeftSpace * 2);
    float dY = self.bounds.size.height / (self.number + 1);

    for (int i = 1; i <= self.number; i++) {
        y = dY * i - (height / 2);
        CGRect rect = CGRectMake(x, y, width, height);
        if (self.shape == SetCardViewShapeOval) {
            [self drawOvalInRect:rect];
        } else if (self.shape == SetCardViewShapeDiamond) {
            [self drawDiamodInRect:rect];
        } else {
            [self drawSquiggleInRect:rect];
        }
    }
}

@end