//
//  GameState.m
//  EmberBaker
//
//  Created by Ember Baker on 8/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameState.h"

static NSString *const GAME_STATE_COIN_KEY = @"GameStateCoinKey";
static NSString *const GAME_STATE_SCORE_KEY = @"GameStateScoreKey";
static NSString *const GAME_STATE_BGMUSIC_KEY = @"GameStateBgKey";
static NSString *const GAME_STATE_SFXMUSIC_KEY = @"GameStateSFXMusicKey";

@implementation GameState {
    OALSimpleAudio *audio;
}

+ (instancetype)sharedInstance {
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc]init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        //        // EXAMPLE
        //        NSNumber *coins = @0;
                
        NSNumber *highScore = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_SCORE_KEY];
        _highScore = [highScore integerValue];
        
        NSNumber *bgMusic = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_BGMUSIC_KEY];
        _bgMusic = [bgMusic boolValue];
        
        NSNumber *sfxMusic = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_SFXMUSIC_KEY];
        _sfxMusic = [sfxMusic boolValue];
        
        
        audio = [OALSimpleAudio sharedInstance];
        
    }
    
    return self;
}



#pragma mark - HighScore Setter Override

- (void)setHighScore:(NSInteger)highScore {
    // store change
    if (highScore>_highScore) {
        _highScore = highScore;
        
        NSNumber *scoreNumber = [NSNumber numberWithInt:highScore];
        
        // broadcast change
        [[NSNotificationCenter defaultCenter]postNotificationName:GAME_STATE_HIGHSCORE_NOTIFICATION object:scoreNumber];
        
        // store change
        [[NSUserDefaults standardUserDefaults]setObject:scoreNumber forKey:GAME_STATE_SCORE_KEY];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

#pragma mark - BG Music
- (void)setBgMusic:(BOOL)bgMusic {
    _bgMusic = bgMusic;
    if (bgMusic) {
        [audio setBgVolume:1.0];
    }
    else {
       [audio setBgVolume:0.0];
    }
    // broadcast change
    
    // store change
}

#pragma mark - SFX
- (void)setSfxMusic:(BOOL)sfxMusic {
    _sfxMusic = sfxMusic;
    if (sfxMusic) {
        [audio setEffectsVolume:1.0];
    }
    else {
        [audio setEffectsVolume:0.0];
    }
    // broadcast change
    
    // store change
}
@end