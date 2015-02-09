//
//  Hud.m
//  EmberBaker
//
//  Created by Ember Baker on 7/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Hud.h"
#import "Gameplay.h"
#import "PauseHud.h"
#import "iAdHelper.h"

@implementation Hud{
    CCLabelTTF *_gameoverLabel;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_pauseScoreLabel;
    CCLabelTTF *_highScoreLabel;
    
    CCNode *_hudNode;
    CCNode *_pauseNode;
    
    Gameplay *game;
    
    PauseHud *pausehud;
}

-(id)init{
    self = [super init];
    if(self){
        _score = 0;
//        game = (Gameplay*)[[Gameplay alloc] init];
        pausehud = (PauseHud*)[[PauseHud alloc] init];
        pausehud.pauseScore = _score;
        _highScoreLabel = _highScore;
        [iAdHelper sharedHelper];
    }
    return self;
}

-(void)showScore: (int)highscore{
    _scoreLabel.string = [NSString stringWithFormat:@"Score: %d", _score];
    _highScoreLabel.string = [NSString stringWithFormat:@"Highscore: %d", highscore];
    
}

-(void)replay{
    CCScene *scene = [CCBReader loadAsScene:@"GameplayScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
    [MGWU logEvent:@"replay_buttonHit" withParams:nil];
}
-(void)twitter{
    [MGWU postToTwitter:[NSString stringWithFormat:@"@theCommuteHell I scored %d in The Commute from Hell! @makeGamesWithUs", _score]];
    [MGWU logEvent:@"Twitter_button" withParams:nil];
}
-(void)mainMenu{
    CCScene *scene= [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
    [MGWU logEvent:@"ReturnedToMainMenu" withParams:nil];
}



@end
