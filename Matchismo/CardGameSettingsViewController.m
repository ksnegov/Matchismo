//
//  CardGameSettingsViewController.m
//  Matchismo
//
//  Created by Konstantin Snegov on 13/08/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "CardGameSettingsViewController.h"
#import "CardGameSettings.h"
#import "CardGameSettingsStore.h"

@interface CardGameSettingsViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *missmatchPenaltyLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchBonusLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipCostLabel;
@property (weak, nonatomic) IBOutlet UIStepper *missmathPenaltyStepper;
@property (weak, nonatomic) IBOutlet UIStepper *matchBonusStepper;
@property (weak, nonatomic) IBOutlet UIStepper *flipCostStepper;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet UIButton *saveSettingsButton;

@property (strong, nonatomic) CardGameSettings *settings;

@end

@implementation CardGameSettingsViewController

- (CardGameSettings *)settings {
    if (!_settings) {
        _settings = [[CardGameSettingsStore sharedStore] cardGameSettings];
    }
    return _settings;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSteppersFromSettings];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)updateUI {
    self.missmatchPenaltyLabel.text = [NSString stringWithFormat:@"Missmatch penalty: %0.f", self.missmathPenaltyStepper.value];
    self.matchBonusLabel.text = [NSString stringWithFormat:@"Match bonus: %0.f", self.matchBonusStepper.value];
    self.flipCostLabel.text = [NSString stringWithFormat:@"Flip cost: %0.f", self.flipCostStepper.value];
}

- (IBAction)settingsValuesChanged {
    [self updateUI];
}

- (IBAction)saveSettings {
    //TODO: show aler and ask save settings or not
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save settings" message:@"Are you really wanna save settings?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        self.undoButton.enabled = NO;
        self.saveSettingsButton.enabled = NO;

        self.settings.missmatchPenalty = self.missmathPenaltyStepper.value;
        self.settings.matchBonus = self.matchBonusStepper.value;
        self.settings.flipCost = self.flipCostStepper.value;
        
        [[CardGameSettingsStore sharedStore] saveCardGameSettings:self.settings];
    }
}

- (IBAction)reloadSettings {
    [self setSteppersFromSettings];
    self.undoButton.enabled = NO;
    self.saveSettingsButton.enabled = NO;
    [self updateUI];
}

- (void)setSteppersFromSettings {
    self.missmathPenaltyStepper.value = self.settings.missmatchPenalty;
    self.matchBonusStepper.value = self.settings.matchBonus;
    self.flipCostStepper.value = self.settings.flipCost;
}

- (IBAction)settingsChanged {
    self.undoButton.enabled = YES;
    self.saveSettingsButton.enabled = YES;
}
@end
