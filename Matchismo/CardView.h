//
//  CardView.h
//  Matchismo
//
//  Created by Konstantin Snegov on 01/09/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardView;

@interface CardView : UIView

@property (nonatomic) BOOL faceUp;
@property (nonatomic) BOOL matched;

- (CGFloat)cornerScaleFactor;
- (CGFloat)cornerRadius;

//abstract
- (void)drawCardInPath:(UIBezierPath *)path;

@end
