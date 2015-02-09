//
//  Weapon.m
//  EmberBaker
//
//  Created by Ember Baker on 7/17/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Weapon.h"

@implementation Weapon

+(Weapon*)makeNewWeapon{
    int weaponType = arc4random_uniform(3);
    
    Weapon *newWeapon;
    
    switch (weaponType) {
        case 0:
            newWeapon = (Weapon*)[CCBReader load:@"Umbrella"];
            [MGWU logEvent:@"umbrella_made" withParams:nil];
            break;
        case 1:
             newWeapon = (Weapon*)[CCBReader load:@"Stroller"];
            [MGWU logEvent:@"Stroller_made" withParams:nil];
            break;
        case 2:
            newWeapon = (Weapon*)[CCBReader load:@"Cane"];
            [MGWU logEvent:@"cane_Made" withParams:nil];
            break;
            
        default:
            newWeapon = (Weapon*)[CCBReader load:@"Stroller"];
            [MGWU logEvent:@"stoller_default_made" withParams:nil];
            break;
    }
    return newWeapon;
}
@end
