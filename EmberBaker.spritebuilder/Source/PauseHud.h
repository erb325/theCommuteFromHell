//
//  PauseHud.h
//  EmberBaker
//
//  Created by Ember Baker on 8/4/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
@class Gameplay;

@interface PauseHud : CCNode

@property (nonatomic, assign) int pauseScore;
-(void)addPauseScore:(int)score;
@property (nonatomic, assign) BOOL soundFlag;
@property (nonatomic, weak) Gameplay *game;
@end
