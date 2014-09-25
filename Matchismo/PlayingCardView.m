//
//  PlayingCardView.m
//  Matchismo
//
//  Created by Konstantin Snegov on 31/08/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "PlayingCardView.h"

@implementation PlayingCardView

static float const PlayingCardViewCornerFontStandartHeight = 180.0;
static float const PlayingCardViewPipHoffsetPercent = 0.165;
static float const PlayingCardViewPipHoffset1Percent = 0.090;
static float const PlayingCardViewPipHoffset2Percent = 0.175;
static float const PlayingCardViewPipHoffset3Percent = 0.270;
static float const PlayingCardViewPipFontScaleFactor = 0.012;

#pragma mark - Setters

- (void)setSuit:(NSString *)suit {
    _suit = suit;
    [self setNeedsDisplay];
}

- (void)setRank:(NSUInteger)rank {
    _rank = rank;
    [self setNeedsDisplay];
}

#pragma mark - Rank

- (NSString *)rankAsString
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"][self.rank];
}

#pragma mark - Drawing helpers

- (CGFloat)cornerScaleFactor {
    return self.bounds.size.height / PlayingCardViewCornerFontStandartHeight;
}

- (CGFloat)cornerOffset {
    return [self cornerRadius] / 3.0;
}

- (UIColor *)colorForSuit {
    UIColor *color;
    if ([@[@"♥︎", @"♦︎"] containsObject:self.suit]) {
        color = [UIColor redColor];
    } else if ([@[@"♠︎", @"♣︎"] containsObject:self.suit]) {
        color = [UIColor blackColor];
    }
    return color;
}

#pragma mark - Context

- (void)pushContextAndRotateUpsideDown {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);    
}

- (void)popContext {
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

#pragma mark - Drawing

- (void)drawCardInPath:(UIBezierPath *)path {
    if (!self.faceUp) {
        [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
        return;
    }
    
    NSString *imageName = [NSString stringWithFormat:@"%@%@", [self rankAsString], self.suit];
    UIImage *faceImage = [UIImage imageNamed:imageName];
    if (faceImage) {
        if (!self.matched) {
            [faceImage drawInRect:self.bounds];
        } else {
            [faceImage drawInRect:self.bounds blendMode:kCGBlendModeNormal alpha:0.5f];
        }
    } else {
        // draw pips
        [self drawPips];
    }
    [self drawCorners];
}

- (void)drawCorners
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];
    
    NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", [self rankAsString], self.suit] attributes:@{ NSFontAttributeName : cornerFont, NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [self colorForSuit] }];

    CGRect textBounds;
    textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
    textBounds.size = [cornerText size];
    [cornerText drawInRect:textBounds];
    
    [self pushContextAndRotateUpsideDown];
    [cornerText drawInRect:textBounds];
    [self popContext];
}

#pragma mark - Drawing pips

- (void)drawPips {
    if ((self.rank == 1) || (self.rank == 5) || (self.rank == 9) || (self.rank == 3)) {
        [self drawPipsWithHorizontalOffset:0 verticalOffset:0 mirroredVertically:NO];
    }
    if ((self.rank == 6) || (self.rank == 7) || (self.rank == 8)) {
        [self drawPipsWithHorizontalOffset:PlayingCardViewPipHoffsetPercent verticalOffset:0 mirroredVertically:NO];
    }
    if ((self.rank == 2) || (self.rank == 3) || (self.rank == 7) || (self.rank == 8) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:0 verticalOffset:PlayingCardViewPipHoffset2Percent mirroredVertically:(self.rank != 7)];
    }
    if ((self.rank == 4) || (self.rank == 5) || (self.rank == 6) || (self.rank == 7) || (self.rank == 8) || (self.rank == 9) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PlayingCardViewPipHoffsetPercent verticalOffset:PlayingCardViewPipHoffset3Percent mirroredVertically:YES];
    }
    if ((self.rank == 9) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PlayingCardViewPipHoffsetPercent verticalOffset:PlayingCardViewPipHoffset1Percent mirroredVertically:YES];
    }
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset verticalOffset:(CGFloat)voffset upsideDown:(BOOL)upsideDown {
    if (upsideDown) {
        [self pushContextAndRotateUpsideDown];
    }
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    UIFont *pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    pipFont = [pipFont fontWithSize:[pipFont pointSize] * self.bounds.size.width * PlayingCardViewPipFontScaleFactor];
    NSAttributedString *attributedSuit = [[NSAttributedString alloc] initWithString:self.suit attributes:@{ NSFontAttributeName : pipFont, NSForegroundColorAttributeName : [self colorForSuit] }];
    CGSize pipSize = [attributedSuit size];
    CGPoint pipOrigin = CGPointMake(
                                    middle.x-pipSize.width/2.0-hoffset*self.bounds.size.width,
                                    middle.y-pipSize.height/2.0-voffset*self.bounds.size.height
                                    );
    [attributedSuit drawAtPoint:pipOrigin];
    if (hoffset) {
        pipOrigin.x += hoffset*2.0*self.bounds.size.width;
        [attributedSuit drawAtPoint:pipOrigin];
    }
    if (upsideDown) {
        [self popContext];
    }
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset verticalOffset:(CGFloat)voffset mirroredVertically:(BOOL)mirroredVertically
{
    [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:NO];
    if (mirroredVertically) {
        [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:YES];
    }
}


@end
