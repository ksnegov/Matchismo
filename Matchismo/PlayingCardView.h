//
//  PlayingCardView.h
//  Matchismo
//
//  Created by Konstantin Snegov on 31/08/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"

@interface PlayingCardView : CardView

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

@end
