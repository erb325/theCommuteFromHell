//
//  Gameover.m
//  TheCommuteFromHell
//
//  Created by Ember Baker on 8/13/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameover.h"
#import "Hud.h"

@implementation Gameover
-(id)init{
    self = [super init];
    if (self){
        _hud = (Hud*)[CCBReader load:@"Hud" owner:self];
          _hud.positionType = CCPositionTypeNormalized;
           _hud.position = ccp(.5  , .5);
        [self addChild:_hud];
    }
    return self;
}


@end
