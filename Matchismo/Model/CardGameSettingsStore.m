//
//  CardGameSettingsStore.m
//  Matchismo
//
//  Created by Konstantin Snegov on 16/08/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "CardGameSettingsStore.h"
#import "CardGameSettings.h"

@implementation CardGameSettingsStore

static NSString * const CardGameSettingsStoreSettings = @"Settings";

+ (instancetype)sharedStore {
    static CardGameSettingsStore *store;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        store = [[CardGameSettingsStore alloc] initPrivate];
    });
    return store;
}

- (instancetype)init {
    return nil;
}

- (instancetype)initPrivate {
    self = [super init];
    return self;
}

- (CardGameSettings *)cardGameSettings {
    CardGameSettings *settings;
    NSDictionary *plist = [[NSUserDefaults standardUserDefaults] objectForKey:CardGameSettingsStoreSettings];
    settings = [[CardGameSettings alloc] initWithPlist:plist];
    if (!settings) {
        settings = [[CardGameSettings alloc] init];
    }
    return settings;
}

- (void)saveCardGameSettings:(CardGameSettings *)settings {
    [[NSUserDefaults standardUserDefaults] setObject:[settings plist] forKey:CardGameSettingsStoreSettings];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
