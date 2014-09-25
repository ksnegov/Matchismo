//
//  ScoreCardGameViewController.m
//  Matchismo
//
//  Created by Konstantin Snegov on 02/08/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "ScoreCardGameViewController.h"
#import "ScoreCardGameManager.h"
#import "ScoreCardGame.h"

@interface ScoreCardGameViewController ()
@property (weak, nonatomic) IBOutlet UITextView *scoresTextView;
@property (strong, nonatomic) NSString *sortDirection;
@property (strong, nonatomic) NSString *sortOrder;
@end

@implementation ScoreCardGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sortOrder = @"score";
    self.sortDirection = @"asc";
}

- (void)updateUI {
    NSMutableString *scoresString = [[NSMutableString alloc] init];
    for (ScoreCardGame *score in [self sortedScores]) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        
        NSLocale *locale = [NSLocale currentLocale];
        [dateFormatter setLocale:locale];
        
        NSString *scoreDescription = [NSString stringWithFormat:@"%@ game: %li started at: %@", score.type == CardGameTypeCard ? @"Card" : @"Set", (long)score.score, [dateFormatter stringFromDate:score.date]];
        
        [scoresString appendString:scoreDescription];
        [scoresString appendString:@"\n"];
        
    }
    self.scoresTextView.text = scoresString;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

- (NSArray *)sortedScores {
    NSArray *scores = [[ScoreCardGameManager sharedManager] scores];
    scores = [scores sortedArrayUsingComparator:[self scoreComporator]];
    return scores;
}

- (NSComparator)scoreComporator {
    NSComparator result = ^(ScoreCardGame *score1, ScoreCardGame *score2) {
        if ([self.sortOrder isEqualToString:@"score"]) {
            if (score1.score > score2.score) {
                if ([self.sortDirection isEqualToString:@"asc"]) {
                    return (NSComparisonResult)NSOrderedAscending;
                } else {
                    return (NSComparisonResult)NSOrderedDescending;
                }
            } else {
                if ([self.sortDirection isEqualToString:@"asc"]) {
                    return (NSComparisonResult)NSOrderedDescending;
                } else {
                    return (NSComparisonResult)NSOrderedAscending;
                }
            }
        } else if ([self.sortOrder isEqualToString:@"gameType"]) {
            if (score1.type > score2.type) {
                if ([self.sortDirection isEqualToString:@"asc"]) {
                    return (NSComparisonResult)NSOrderedAscending;
                } else {
                    return (NSComparisonResult)NSOrderedDescending;
                }
            } else {
                if ([self.sortDirection isEqualToString:@"asc"]) {
                    return (NSComparisonResult)NSOrderedDescending;
                } else {
                    return (NSComparisonResult)NSOrderedAscending;
                }
            }
        } else {
            if ([score1.date isEqualToDate:score2.date]) {
                if ([self.sortDirection isEqualToString:@"asc"]) {
                    return (NSComparisonResult)NSOrderedAscending;
                } else {
                    return (NSComparisonResult)NSOrderedDescending;
                }
            } else {
                if ([self.sortDirection isEqualToString:@"asc"]) {
                    return (NSComparisonResult)NSOrderedDescending;
                } else {
                    return (NSComparisonResult)NSOrderedAscending;
                }
            }
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    return result;
}

- (void)changeSortDirection {
    if ([self.sortDirection isEqualToString:@"asc"]) {
        self.sortDirection = @"desc";
    } else {
        self.sortDirection = @"asc";
    }
}

- (IBAction)sortScore {
    if ([self.sortOrder isEqualToString:@"score"]) {
        [self changeSortDirection];
    } else {
        self.sortOrder = @"score";
        self.sortDirection = @"asc";
    }
    [self updateUI];
}

- (IBAction)sortGameType {
    if ([self.sortOrder isEqualToString:@"gameType"]) {
        [self changeSortDirection];
    } else {
        self.sortOrder = @"gameType";
        self.sortDirection = @"asc";
    }
    [self updateUI];
}
- (IBAction)sortDate {
    if ([self.sortOrder isEqualToString:@"date"]) {
        [self changeSortDirection];
    } else {
        self.sortOrder = @"date";
        self.sortDirection = @"asc";
    }
    [self updateUI];
}

@end
