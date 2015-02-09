//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "GameState.h"

@implementation MainScene{
    OALSimpleAudio *audio;
}
-(void)didLoadFromCCB{
    audio = [OALSimpleAudio sharedInstance];
    [audio preloadEffect:@"classic_video_game_level_up.mp3"];
    [audio preloadEffect:@"explosion_medium_dirt_clusters.mp3"];
    [audio preloadEffect:@"auto_horn_1972_toyota_single_short_blast.mp3"];
    [audio preloadEffect:@"punch9.mp3"];
    [audio preloadEffect:@"science_fiction_laser_gun_or_beam_fire_version_1.mp3"];
    [audio playBg:@"exciting_race_tune.mp3" volume:.6 pan:0 loop:TRUE];
    [[GameState sharedInstance] setBgMusic:[GameState sharedInstance].bgMusic];
    
}

-(void)play {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Tutorial"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
    [MGWU logEvent:@"Play_button" withParams:nil];
}
-(void)run{

    CCScene *gameplayScene = [CCBReader loadAsScene:@"GameplayScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
    [MGWU logEvent:@"Tutorial_run_button" withParams:nil];
}
-(void)moreGames{
    [MGWU displayCrossPromo];
    [MGWU logEvent:@"crossPromo" withParams:nil];
}
-(void)about{
   // [MGWU displayAboutPage];
    CCScene *scene = [CCBReader loadAsScene:@"AboutScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
    [MGWU logEvent:@"aboutPage" withParams:nil];
}
-(void)back{
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
    [MGWU logEvent:@"returnToMainScreen"];
}


@end
