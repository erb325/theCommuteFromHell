//
//  PauseHud.m
//  EmberBaker
//
//  Created by Ember Baker on 8/4/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PauseHud.h"
#import "GameState.h"
#import "Gameplay.h"
#import "iAdHelper.h"

@implementation PauseHud{
    CCLabelTTF *_pauseScoreLabel;
    OALSimpleAudio *audio;
//    BOOL _audioIsOn;
//    CCButton *_audioButton;
}

-(id)init{
    self = [super init];
    if(self){
        _pauseScore = 0;
        _soundFlag = TRUE;
        
        audio = [OALSimpleAudio sharedInstance];
        
    }
    return self;
}
-(void)audio{
    //[GameState sharedInstance].bgMusic = FALSE;
    //[audio stopAllEffects];
    
}

-(void)resume{
    //[[iAdHelper sharedHelper] removeFromParentAndCleanup:YES];
    [[CCDirector sharedDirector] resume];
    [self.game resume];
    [self removeFromParentAndCleanup:YES];
}

-(void) addPauseScore:(int)score{
    _pauseScore= score;
    _pauseScoreLabel.string =[NSString stringWithFormat:@"Score: %d", _pauseScore];
}


@end
