//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Konstantin Snegov on 31/07/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *historyTextView;
@end

@implementation HistoryViewController

- (void)updateUI {
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] init];
    for (NSAttributedString *attributedString in self.history) {
        [mutableString appendAttributedString:attributedString];
        [mutableString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }
    NSRange range = NSMakeRange(0, [mutableString length]);
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [mutableString addAttributes:@{ NSFontAttributeName : font } range:range];
    self.historyTextView.attributedText = [mutableString copy];
}

- (void)setHistory:(NSArray *)history {
    _history = history;
    if (self.view.window) {
        [self updateUI];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}



@end
