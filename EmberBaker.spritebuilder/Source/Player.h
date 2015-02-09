//
//  Player.h
//  EmberBaker
//
//  Created by Ember Baker on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Weapon.h"

@interface Player : CCNode

@property (nonatomic, assign) NSInteger health;
@property (nonatomic, strong) CCSprite* health1;
@property (nonatomic, strong) CCSprite* health2;
@property (nonatomic, strong) CCSprite* health3;
@property (nonatomic, strong) CCSprite* health4;
@property (nonatomic, strong) CCSprite* health5;
@property (nonatomic, strong) CCSprite* health6;

-(void)updateHealth;
-(Weapon*)spawnWeapon;
-(void) gameover;
-(CCNode*)spawnWeaponBox;
-(void) addHeart;


@end
