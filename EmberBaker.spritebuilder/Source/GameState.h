//
//  GameState.h
//  EmberBaker
//
//  Created by Ember Baker on 8/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const GAME_STATE_SCORE_NOTIFICATION = @"GameState_ScoreChanged";
static NSString *const GAME_STATE_HIGHSCORE_NOTIFICATION = @"GameState_HighScoreChanged";
static NSString *const GAME_STATE_BGMUSIC_NOTIFICATION = @"GameState_BGMusic";

@interface GameState : NSObject

+ (instancetype)sharedInstance;


@property (nonatomic, assign) NSInteger highScore;
@property (nonatomic, assign) BOOL bgMusic;
@property (nonatomic, assign) BOOL sfxMusic;

@end
