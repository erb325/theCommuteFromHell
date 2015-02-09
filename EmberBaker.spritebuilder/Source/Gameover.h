//
//  Gameover.h
//  TheCommuteFromHell
//
//  Created by Ember Baker on 8/13/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
@class Hud;
@class Gameplay;
@interface Gameover : CCNode
@property (nonatomic, weak) Hud *hud;
@property (nonatomic, weak)Gameplay *game;

@end
