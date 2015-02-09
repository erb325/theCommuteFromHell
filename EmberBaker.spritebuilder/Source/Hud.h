//
//  Hud.h
//  EmberBaker
//
//  Created by Ember Baker on 7/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Hud : CCNode
@property (nonatomic, assign) int score;
@property (nonatomic, strong) CCLabelTTF* highScore;
-(void)showScore:(int)highscore;


@end
