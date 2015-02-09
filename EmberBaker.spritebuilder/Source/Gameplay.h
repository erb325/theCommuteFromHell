//
//  Gameplay.h
//  EmberBaker
//
//  Created by Ember Baker on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
//#import "AppKit"

@interface Gameplay : CCNode <CCPhysicsCollisionDelegate>

@property (nonatomic, assign) float newTimer;
-(void)resume;
//-(void)onAudioClicked:(id)sender;

@end
