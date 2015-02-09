//
//  PowerUps.m
//  EmberBaker
//
//  Created by Ember Baker on 7/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PowerUps.h"

@implementation PowerUps

+(PowerUps*) makeNewPowerUp {
    int powerUpType = arc4random_uniform(4);
    PowerUps *powerUp;
    switch (powerUpType) {
        case 1:
            powerUp = (PowerUps *)[CCBReader load:@"Coffee"];
            [MGWU logEvent:@"Coffee_made" withParams:nil];
            break;
        case 2:
            powerUp = (PowerUps *)[CCBReader load:@"Heart"];
            [MGWU logEvent:@"heart_made" withParams:nil];
            break;
        case 3:
            powerUp = (PowerUps*)[CCBReader load:@"2x"];
            [MGWU logEvent:@"2x_made" withParams:nil];
            break;
        default:
            powerUp = (PowerUps *)[CCBReader load:@"2x"];
            [MGWU logEvent:@"2x_default_made" withParams:nil];
            break;
    }
    return powerUp;
}

@end
