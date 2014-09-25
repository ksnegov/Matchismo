//
//  SetCard.h
//  Matchismo
//
//  Created by Konstantin Snegov on 28/07/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSUInteger number;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shade;
@property (strong, nonatomic) NSString *color;

+ (NSArray *)validSymbol;
+ (NSArray *)validShade;
+ (NSArray *)validColor;
+ (NSUInteger)minNumber;
+ (NSUInteger)maxNumber;

- (NSString *)symbols;

@end
