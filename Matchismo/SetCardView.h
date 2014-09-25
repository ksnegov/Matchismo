//
//  SetCardView.h
//  Matchismo
//
//  Created by Konstantin Snegov on 03/09/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "CardView.h"

typedef NS_ENUM(NSUInteger, SetCardViewShape) {
    SetCardViewShapeDiamond,
    SetCardViewShapeSquiggle,
    SetCardViewShapeOval
};

typedef NS_ENUM(NSUInteger, SetCardViewShade){
    SetCardViewShadeSolid,
    SetCardViewShadeStriped,
    SetCardViewShadeOpen
};

@interface SetCardView : CardView

@property (nonatomic) NSUInteger number;
@property (nonatomic) SetCardViewShape shape;
@property (nonatomic) SetCardViewShade shade;
@property (strong, nonatomic) UIColor *color;

@end
