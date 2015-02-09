//
//  Player.m
//  EmberBaker
//
//  Created by Ember Baker on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Player.h"
#import "Weapon.h"


@implementation Player{
    CCSprite *_health5;
    CCSprite *_health4;
    CCSprite *_health3;
    CCSprite *_health2;
    CCSprite *_health1;
    CCSprite *_health6;
    CCSprite *_playerSprite;
    
    CCSprite *_redLayer;
    
    CCNode *_weaponNode;
    CCNode *_weaponBox;
    
}
int _health;

-(id)init{
    self= [super init];
    
    if (self) {
        _health = 5;
    }
    return self;
}


-(void)updateHealth{
    _health--;
    
    NSLog(@"health = %ld", (long)_health);
    
    switch (_health) {
        case 5:
            _health6.visible  =FALSE;
            break;
        case 4:
            _health5.visible =FALSE;
            break;
        case 3:
            _health4.visible=FALSE;
            break;
        case 2:
            _health3.visible = FALSE;
            break;
        case 1:
            _health2.visible =FALSE;
            break;
        case 0 :
            _health1.visible = FALSE;
            [self gameover];
        default:
            break;
    }
}

-(void)addHeart{
    _health++;
    
    switch (_health) {
        case 6:
            _health6.visible = TRUE;
            break;
        case 5:
            _health5.visible =TRUE;
            break;
        case 4:
            _health4.visible=TRUE;
            break;
        case 3:
            _health3.visible = TRUE;
            break;
        case 2:
            _health2.visible =TRUE;
            break;
        case 1 :
            _health1.visible = TRUE;
            
        default:
            _health =6;
            break;
    }
    
}

-(CCNode*)spawnWeaponBox{
    _weaponBox = (Player*)[CCBReader load:@"weaponBox"];
    return _weaponBox;
}


-(Weapon *)spawnWeapon{
    Weapon *weapon = (Weapon*)[Weapon makeNewWeapon];
    [_weaponNode addChild:weapon];
    return weapon;
}



-(void) gameover{
    _health1.visible = FALSE;
    _health2.visible = FALSE;
    _health3.visible = FALSE;
    _health4.visible = FALSE;
    _health5.visible = FALSE;
    _health6.visible = FALSE;
    _health = 0;
    
    [self removeFromParent];
    
    
}

@end
