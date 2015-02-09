//
//  Enemy.m
//  EmberBaker
//
//  Created by Ember Baker on 7/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Enemy.h"
#import "Gameplay.h"



@implementation Enemy

+(Enemy*) makeNewEnemy {
    int enemyType = arc4random_uniform(5);
    Enemy *newEnemy;
    switch (enemyType) {
        case 0:
            newEnemy = (Enemy*)[CCBReader load:@"OldWoman"];
            break;
        case 1:
            newEnemy = (Enemy*)[CCBReader load:@"Homeless"];
            break;
        case 2:
            newEnemy = (Enemy*)[CCBReader load:@"HatGuy"];
            break;
        case 3:
            newEnemy = (Enemy*)[CCBReader load:@"FatGuy"];
            break;
        case 4:
            newEnemy = (Enemy*)[CCBReader load:@"Taxi"];
            break;
        default:
            break;
    }
    return newEnemy;
}

@end
