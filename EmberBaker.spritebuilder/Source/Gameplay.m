//
//  Gameplay.m
//  EmberBaker
//
//  Created by Ember Baker on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Player.h"
#import "CCPhysics+ObjectiveChipmunk.h"
#import "Enemy.h"
#import "Weapon.h"
#import "Hud.h"
#import "PowerUps.h"
#import "PauseHud.h"
#import "GameState.h"
#import "Gameover.h"

int kScrollSpeed = 2;
int rScrollSpeed = 3;
int seconds=0;
float enemyTime;
BOOL flag ;
int  enemySpeed;
BOOL gameoverFlag;
float timeSinceObstacle=0.0f;
float timeSinceWeapon = 0.0f;
float timeSincePowerup = 0.0f;
BOOL _strollerFlag;
int multiplier;
int weaponBoxCount;
int enemiesKilledCount;
int powerUpsCollected;
int timeLeft;

@implementation Gameplay {
    
    CCNode *_uiNode;
    CCNode *_lane1;
    CCNode *_lane2;
    CCNode *_lane3;
    CCNode *_roads1;
    CCNode *_roads2;
    CCNode *_city3;
    CCNode *_city4;
    CCNode *_contentNode;
    CCNode *_lane;
    CCNode *_city1;
    CCNode *_city2;
    CCNode *_weaponNode;
    CCNode *_weaponBox;
    CCNode *_timerBox;
    CCNode *_scoreBox;
    
    CCSprite *_health1;
    CCSprite *_health2;
    CCSprite *_health3;
    CCSprite *_health4;
    CCSprite *_health5;
    CCSprite *_health6;
    CCSprite *_playerSprite;
    
    CCButton *_pause;
    CCButton *_audioButton;
    CCButton *_sfxButton;
    
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_timerLabel;
    CCLabelTTF *_highScoreLabel;
    CCLabelTTF *_pauseScoreLabel;
    
    CCPhysicsNode *_physicsNode;
    
    CCNodeColor *_blueNode;
    CCNodeColor *_redNode;
    CCNodeColor *_greenNode;
    
    NSMutableArray *_playerRemoved;
    NSMutableArray *_enemyArray;
    NSMutableArray *_weaponArray;
    NSMutableArray *_powerUpArray;
    NSMutableArray *_enemyRemoved;
    NSMutableArray *_weaponRemoved;
    NSMutableArray *_powerUpRemoved;
    
    Player *player;
    
    Enemy *_enemy;
    
    Weapon *_weapon;
    
    PowerUps *_powerUp;
    
    Hud *_hud;
    PauseHud *_pauseHud;
    
    NSInteger weaponBoxSpeed;
    NSInteger powerUpSpeed;
    
    BOOL weaponFlag;
    BOOL _audioIsOn;
    BOOL _sfxIsOn;
    BOOL musicPlaying;
    BOOL soundIsPlaying;
    
    OALSimpleAudio *audio;
}

#pragma mark DidLoad and MakeEnemy

-(void)didLoadFromCCB {
    
#pragma mark soundflags
    [[GameState sharedInstance] setBgMusic:[GameState sharedInstance].bgMusic];
    [[GameState sharedInstance] setSfxMusic:[GameState sharedInstance].sfxMusic];
    
#pragma mark touch enabled
    
    //tell this scene to accept touch
    self.userInteractionEnabled =TRUE;
    
#pragma mark loading huds
    _hud = (Hud *)[CCBReader load:@"Hud" owner:self];
    _hud.score=0;
    [GameState sharedInstance].highScore = _hud.score;
    _pauseHud = (PauseHud*)[CCBReader load:@"PauseHud" owner:self];
    _pauseHud.game= self;
#pragma mark audio
    audio = [OALSimpleAudio sharedInstance];
    if([GameState sharedInstance].bgMusic){
        [audio playBg:@"exciting_race_tune.mp3" loop:TRUE];
    }
    _audioButton = [CCButton buttonWithTitle:@"Music: ON" fontName:@"Helvetica" fontSize:20.0f];
    _audioButton.positionType = CCPositionTypeNormalized;
    _audioButton.position = ccp(0.5f, 0.25f);
    [_audioButton setTarget:self selector:@selector(onAudioClicked:)];
    [_pauseHud addChild:_audioButton];
    _audioIsOn = TRUE;
   
#pragma mark sfx
    _sfxButton = [CCButton buttonWithTitle:@"Sound Effects: ON" fontName:@"Helvetica" fontSize:20.0f ];
    _sfxButton.positionType = CCPositionTypeNormalized;
    _sfxButton.position = ccp(0.5f, 0.10f);
    [_sfxButton setTarget:self selector:@selector(onSfxClicked:)];
    [_pauseHud addChild:_sfxButton];
    _sfxIsOn = TRUE;
    
#pragma mark spawn player
    //setup and spawn player here
    player = (Player*)[CCBReader load:@"Player"];
    player.position = ccp(player.position.x+20, player.position.y+10);
    [self addPlayerSprite];
      _playerSprite = (CCSprite*)[CCBReader load:@"PlayerSprite"];
    
       [player addChild:_playerSprite];
    [_lane2 addChild:player];
    
#pragma mark Player heath setup
    //set heath code connetions to the player health to access
    player.health1 = _health1;
    player.health2 = _health2;
    player.health3 = _health3;
    player.health4 = _health4;
    player.health5 = _health5;
    player.health6 = _health6;
    
#pragma mark mutable arrays setup
    _enemyArray = [@[] mutableCopy];
    _weaponArray = [@[] mutableCopy];
    _powerUpArray = [@[] mutableCopy];
    _enemyRemoved = [@[] mutableCopy];
    _weaponRemoved = [@[] mutableCopy];
    _powerUpRemoved = [@[] mutableCopy];
    _playerRemoved = [@[] mutableCopy];
    
#pragma mark PHYSICS DEBUG HERE
    //other things that need to happen
    _physicsNode.collisionDelegate = self;
    //_physicsNode.debugDraw = TRUE;
    
#pragma mark UISwipe Setup
    //setup UISwipe gesteres
    UISwipeGestureRecognizer * swipeUp= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer * swipeDown= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeDown];
    
#pragma mark Speed
    weaponBoxSpeed = 85;
    powerUpSpeed =75;
    _newTimer = 0.0;
    enemyTime = 2.0;
    
#pragma mark flags
    gameoverFlag = FALSE;
    flag =FALSE;
    
#pragma mark counters
    multiplier=1;
    weaponBoxCount = 0;
    enemiesKilledCount=0;
    powerUpsCollected = 0;
    _hud.highScore = _highScoreLabel;
    
#pragma mark city scoll
    float delay = 0.1f;
    [self performSelector:@selector(cityScroll) withObject:nil afterDelay:delay];
    
    enemySpeed = 150;
}

-(void)cityScroll{
    CCAnimationManager* animationManager = self.animationManager;
    [animationManager runAnimationsForSequenceNamed:@"ForgroundCity"];
}

- (void)highScoreChanged:(NSNotification *)notification {
    NSNumber *newHighScoreValue = [notification object];
    _highScoreLabel.string = [NSString stringWithFormat:@"High Score to beat: %d", [newHighScoreValue integerValue]];
}

#pragma mark pause and resume
-(void)pause{
    flag = TRUE;
    _pause.enabled = NO;
    [[CCDirector sharedDirector] pause];
    _pauseHud.positionType = CCPositionTypeNormalized;
    _pauseHud.position = ccp(.5 , .5);
    _pauseScoreLabel.string =[NSString stringWithFormat:@"Score: %d", _hud.score];
    [self addChild:_pauseHud];
    [MGWU logEvent:@"Pause_active" withParams:nil];
}

-(void)resume{
    _pause.enabled = YES;
    [_pauseHud removeFromParentAndCleanup:YES];
    [MGWU logEvent:@"resume_button" withParams:nil];
    flag = FALSE;
    
}
#pragma mark audioMethods

-(void)onAudioClicked:(id)sender
{
    // if the audio is off, turn it on, if it's on turn it off
    if (!_audioIsOn)
    {
        [_audioButton setTitle:@"MUSIC: ON"];
        [GameState sharedInstance].bgMusic= TRUE;
        _audioIsOn = TRUE;
    }
    else
    {
        [_audioButton setTitle:@"MUSIC: OFF"];
        [GameState sharedInstance].bgMusic = FALSE;
        _audioIsOn = FALSE;
        
    }
}
-(void)onSfxClicked:(id)sender
{
    // if the audio is off, turn it on, if it's on turn it off
    if (!_sfxIsOn)
    {
        [_sfxButton setTitle:@"Sound Effects: ON"];
        [GameState sharedInstance].sfxMusic= TRUE;
        _sfxIsOn = TRUE;
    }
    else
    {
        [_sfxButton setTitle:@"Sound Effects: OFF"];
        [GameState sharedInstance].sfxMusic= FALSE;
        _sfxIsOn  = FALSE;
        
    }
}


#pragma mark timer methods
- (NSString*)getTimeStr : (int) secondsElapsed {
    int seconds = secondsElapsed % 60;
    int minutes = secondsElapsed / 60;
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    
}
- (void)timerController {
    _timerLabel.string = [self getTimeStr:_newTimer];
    
    if (_newTimer >15.0) {
        enemyTime = 1.5;
    } else if( _newTimer >30.0){
        enemyTime = 1.25;
    }else if (_newTimer >45.0){
        enemyTime =1.0;
    }else if (_newTimer >60.0){
        enemyTime = .75;
    }else if(_newTimer >75.0){
        enemyTime = 0.5;
    } else if (_newTimer > 90.0){
        enemyTime = 0.25;
    }
}
-(void)onTickWeapon{
    //make a weapon box every timer the tumer is called
    [self setWeaponBox];
}

-(void)onTickPowerUp{
    [self makeNewPowerUp];
}

-(void)weaponRemoval{
    //remove weapon after timer is up
    [_weapon removeFromParent];
    [self weaponFlag];
}
-(void)weaponFlag{
    weaponFlag = FALSE;
}

#pragma mark spawningMethods

-(void)makeNewEnemy:(int)atX{
    //call makeNewEnemy spawn in correct spot
    
    Enemy *enemy = (Enemy*)[Enemy makeNewEnemy];
    enemy.physicsBody.collisionGroup = self;
    
    CCNode *lane = [self pickLane];
    [lane addChild:enemy];
    
    enemy.position = ccp([UIScreen mainScreen].bounds.size.width + atX, self.position.y+10);
    _enemy = enemy;
    [_enemyArray addObject:_enemy];
    
    _hud.score +=multiplier*(50);
    [GameState sharedInstance].highScore = _hud.score;
    
    enemySpeed += 5;
}

-(void)setWeaponBox{
    //call spawnWeaponBox and spawn in the correct spot
    CCNode *weaponBox = [player spawnWeaponBox];
    weaponBox.physicsBody.collisionGroup = self;
    
    weaponBox.position = ccp([UIScreen mainScreen].bounds.size.width+300, weaponBox.position.y);
    
    CCNode *lane = [self pickLane];
    [lane addChild:weaponBox];
    
    _weaponBox= weaponBox;
    [_weaponArray addObject:_weaponBox];
}

-(void)makeNewPowerUp{
    PowerUps *powerUp = (PowerUps*)[PowerUps makeNewPowerUp];
    powerUp.physicsBody.collisionGroup = self;
    powerUp.position = ccp([UIScreen mainScreen].bounds.size.width+400, powerUp.position.y);
    
    CCNode *lane = [self pickLane];
    [lane addChild:powerUp];
    
    _powerUp = powerUp;
    [_powerUpArray addObject:_powerUp];
}

-(CCNode*)pickLane{
    int random = arc4random_uniform(3);
    switch (random) {
        case 1:
            return _lane1;
            break;
        case 2:
            return _lane2;
            break;
        default:
            return _lane3;
            break;
    }
}

#pragma mark Swipe methods

-(void)removePlayerSprite: (CCSprite*)temp{
    temp = _playerSprite;
    [_playerRemoved addObject:temp];
    _playerRemoved = [NSMutableArray array];
}
-(void)addPlayerSprite{
    _playerSprite = (CCSprite*)[CCBReader load:@"PlayerSprite"];
    //_playerSprite.position = ccp(player.position.x, player.position.y +8);
    [player addChild:_playerSprite];
}

-(void)swipeUp{
    if(player.parent == _lane2) {
        [player removeFromParentAndCleanup:YES];
        [self removePlayerSprite:_playerSprite];
        [self addPlayerSprite];
        [_lane3 addChild:player];
    }
    if (player.parent == _lane1){
        [player removeFromParent];
        [self removePlayerSprite:_playerSprite];
        [self addPlayerSprite];
        [_lane2 addChild:player];
    }
}

-(void)swipeDown{
    if (player.parent == _lane2){
        [player removeFromParent];
        [self removePlayerSprite:_playerSprite];
        [self addPlayerSprite];
        [_lane1 addChild:player];
    }
    if(player.parent ==_lane3){
        [player removeFromParent];
        [ self removePlayerSprite:_playerSprite];
        [self addPlayerSprite];
        [_lane2 addChild:player];
    }
}

#pragma mark scrolling methods
-(void)roadsScrolling{
    CGPoint bg1Pos = _roads1.position;
    CGPoint bg2Pos = _roads2.position;
    bg1Pos.x -= rScrollSpeed;
    bg2Pos.x -= rScrollSpeed;
    
    if (bg1Pos.x < -(_roads1.contentSize.width))
    {
        bg1Pos.x += _roads1.contentSize.width;
        bg2Pos.x += _roads2.contentSize.width;
    }
    
    bg1Pos.x = (int)bg1Pos.x;
    bg2Pos.x = (int)bg2Pos.x;
    _roads1.position = bg1Pos;
    _roads2.position = bg2Pos;
    
}

-(void)backgroundCityScrolling{
    CGPoint bg1Pos = _city3.position;
    CGPoint bg2Pos = _city4.position;
    bg1Pos.x -= kScrollSpeed;
    bg2Pos.x -= kScrollSpeed;
    
    if (bg1Pos.x < -(_city3.contentSize.width))
    {
        bg1Pos.x += _city3.contentSize.width;
        bg2Pos.x += _city4.contentSize.width;
    }
    
    bg1Pos.x = (int)bg1Pos.x;
    bg2Pos.x = (int)bg2Pos.x;
    _city3.position = bg1Pos;
    _city4.position = bg2Pos;
}

#pragma mark update method

-(void)update:(CCTime)delta{
    
    _scoreLabel.string = [NSString stringWithFormat:@"%d", _hud.score];
    if (flag == FALSE) {
        //main timer
        _newTimer +=delta;
        [self timerController];
        
        //enemyTimer
        timeSinceObstacle += delta;
        if(timeSinceObstacle >enemyTime){
            [self makeNewEnemy:300];
            [self makeNewEnemy:500];
            
            if (60<_newTimer<90) {
                [self makeNewEnemy:700];
            }else if (90<_newTimer<120){
                [self makeNewEnemy:900];
                [self makeNewEnemy:800];
            }
            
            timeSinceObstacle = 0.0f;
        }
        
        //weaponTimer
        timeSinceWeapon +=delta;
        if (timeSinceWeapon>12.0f) {
            [self setWeaponBox];
            timeSinceWeapon  = 0.0f;
        }
        
        //powerUpTimer
        timeSincePowerup +=delta;
        if(timeSincePowerup >18.0f){
            [self makeNewPowerUp];
            timeSincePowerup = 0.0f;
        }
        
    }
#pragma mark enemy movement and removal
    for (Enemy* enemy in _enemyArray){
        enemy.position = ccp(enemy.position.x -(enemySpeed*delta),enemy.position.y );
        
        if (enemy.position.x +100 <= enemy.parent.position.x){
            _enemy = enemy;
            [_enemy removeFromParentAndCleanup:YES];
            [_enemyRemoved addObject:_enemy];
        }
    }
    for (Enemy* enemy in _enemyRemoved) {
        [_enemyArray removeObject:enemy];
    }
    _enemyRemoved = [NSMutableArray array];
    
#pragma mark weaponbox movement and removal
    for(Weapon *weaponBox in _weaponArray){
        weaponBox.position = ccp(weaponBox.position.x -(weaponBoxSpeed*delta),weaponBox.position.y );
        
        if (weaponBox.position.x +100 <= weaponBox.parent.position.x){
            _weaponBox = weaponBox;
            [_weaponBox removeFromParentAndCleanup:YES];
            [_weaponRemoved addObject:_weaponBox];
        }
    }
    
    for(Weapon* weaponBox in _weaponRemoved){
        [_weaponArray removeObject:weaponBox];
    }
    _weaponRemoved = [NSMutableArray array];
    
#pragma mark PowerUp movement and removal
    for(PowerUps *powerUp in _powerUpArray){
        powerUp.position = ccp(powerUp.position.x - (powerUpSpeed*delta),powerUp.position.y);
        
        if (powerUp.position.x +100 <= powerUp.parent.position.x){
            _powerUp = powerUp;
            [_powerUp removeFromParentAndCleanup:YES];
            [_powerUpRemoved addObject:_powerUp];
        }
    }
    
    for(PowerUps* powerUp in _powerUpRemoved){
        [_powerUpArray removeObject:powerUp];
    }
    
    _powerUpRemoved = [NSMutableArray array];
    
#pragma mark scorlling
    //  [self cityScrolling];
    [self roadsScrolling];
    [self backgroundCityScrolling];
    
#pragma mark scaling
    if (player.parent == _lane1){
        player.scale = 1.1;
    }
    if (player.parent == _lane2){
        player.scale = 1.0;
    }
    if (player.parent == _lane3) {
        player.scale = 0.9;
    }
    
}

#pragma mark gameover methods
-(void)gameover{
    gameoverFlag=TRUE;
    
    _pause.visible = FALSE;
    CCScene *scene = [CCBReader loadAsScene:@"GameoverScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
    _hud.positionType = CCPositionTypeNormalized;
    _hud.position = ccp(.5  , .5);
    _scoreBox.visible =FALSE;
    _scoreLabel.visible = FALSE;
    _timerBox.visible=FALSE;
    _timerLabel.visible = FALSE;
    
    [_hud showScore:[GameState sharedInstance].highScore];
    if (_hud.score >= [GameState sharedInstance].highScore) {
        _highScoreLabel.string = [NSString stringWithFormat:@"You got the higest score!"];
    }
    else {
        _highScoreLabel.string = [NSString stringWithFormat:@"Highscore to beat: %d", [GameState sharedInstance].highScore];
    }
    
    [self addChild:_hud];
    [player removeFromParentAndCleanup:YES];
    [player gameover];
    [self gameoverAnaltics];
    
}

-(void)gameoverAnaltics{
    NSNumber *timer = [[NSNumber alloc] initWithFloat:_newTimer];
    NSDictionary *timerParams = [[NSDictionary alloc] initWithObjectsAndKeys: timer, @"Timer: " , nil];
    [MGWU logEvent:@"Timer_at_Gameover" withParams:timerParams];
    
    NSNumber *enemiesKilled = [[NSNumber alloc] initWithInt:enemiesKilledCount];
    NSDictionary *enemiesParams = [[NSDictionary alloc]initWithObjectsAndKeys:enemiesKilled, @"EnemiesKilled", nil];
    [MGWU logEvent:@"EnemiesKilledCount" withParams:enemiesParams];
    
    NSNumber *weaponBoxAna = [[NSNumber alloc] initWithInt:weaponBoxCount];
    NSDictionary *weaponBoxParams = [[NSDictionary alloc]initWithObjectsAndKeys:weaponBoxAna, @"WeaponBoxes", nil];
    [MGWU logEvent:@"WeaponBoxCount" withParams:weaponBoxParams];
    
    NSNumber *powerUpsCollectedana = [[NSNumber alloc] initWithInt:powerUpsCollected];
    NSDictionary *powerUpParams = [[NSDictionary alloc]initWithObjectsAndKeys:powerUpsCollectedana, @"PowerUps", nil];
    [MGWU logEvent:@"PowerUpCounter" withParams:powerUpParams];
    
    NSNumber *multiplierAna = [[NSNumber alloc] initWithInt:multiplier];
    NSDictionary *multiplierParams = [[NSDictionary alloc]initWithObjectsAndKeys:multiplierAna, @"Mulitplier", nil];
    [MGWU logEvent:@"MultiplierCount" withParams:multiplierParams];
    
    NSNumber *finalScore = [[NSNumber alloc] initWithInt:_hud.score];
    NSDictionary *Scoreparms = [[NSDictionary alloc] initWithObjectsAndKeys: finalScore, @"FinalScore: ", nil];
    [MGWU logEvent:@"Gameover" withParams:Scoreparms];
}


#pragma marks powerup methods

-(void)powerUpAction {
    //coffee powerup
    kScrollSpeed = 10;
    [audio playEffect:@"science_fiction_laser_gun_or_beam_fire_version_1.mp3"];
    rScrollSpeed = 9;
    _hud.score +=15;
    weaponBoxSpeed =70;
    enemySpeed = 180;
    player.physicsBody.collisionMask = @[];
    [self performSelector:@selector(returnToNormal) withObject:_powerUp afterDelay:10];
}

-(void)returnToNormal{
    kScrollSpeed = 4;
    rScrollSpeed = 3;
    weaponBoxSpeed = 90;
    enemySpeed = 100;
    player.physicsBody.collisionMask = nil;
}

-(void)changeColorNormal{
    _redNode.visible = FALSE;
}

#pragma mark physicsMethods

//if enemy collides with player deplete health

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemy:(Enemy *)enemy playerCollide:(Player *)playerCollide{
    if(enemy.parent == playerCollide.parent && !weaponFlag)
    {
        [player updateHealth];
        CCParticleSystem *playerCollision = (CCParticleSystem*)[CCBReader load:@"Collision"];
        playerCollision.autoRemoveOnFinish = TRUE;
        playerCollision.position = ccp(enemy.position.x, playerCollide.position.y +26);
        [enemy addChild:playerCollision];
        [audio playEffect:@"punch9.mp3"];
        
        _redNode.visible =TRUE;
        
        [self performSelector:@selector(changeColorNormal) withObject:self afterDelay:.5];
        if (player.health == 0) {
            [self gameover];
            [MGWU logEvent:@"Death_by_health" withParams:nil];
            
        }
        enemy.physicsBody = FALSE;
        
        return TRUE;
    } else {
        return FALSE;
    }
    
    
}

//if vehical collides with a player kill player
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair vehical:(Enemy *)vehical playerCollide:(Player *)playerCollide{
    
    if (vehical.parent == playerCollide.parent){
        CCParticleSystem *playerCollision = (CCParticleSystem*)[CCBReader load:@"Collision"];
        playerCollision.autoRemoveOnFinish = TRUE;
        playerCollision.position = ccp(vehical.position.x, vehical.position.y +26);
        [vehical addChild:playerCollision];
        [audio playEffect:@"auto_horn_1972_toyota_single_short_blast.mp3"];
        [player gameover];
        [self gameover];
        [MGWU logEvent:@"Death_by_taxi" withParams:nil];
        return TRUE;
    }
    else{
        return FALSE;
    }
}

//if player hits a weapon box spawn weapon
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair weaponBox:(Player *)weaponBox playerCollide:(Player *)playerCollide{
    
    if (weaponBox.parent == playerCollide.parent){
        
        _weapon = [player spawnWeapon];
        [self performSelector:@selector(weaponRemoval) withObject:_weapon afterDelay:9];
        [weaponBox removeFromParentAndCleanup:YES];
        
        weaponFlag =TRUE;
        weaponBoxCount++;
        
        return TRUE;
    }
    else{
        return FALSE;
    }
}



//when weapon node collides with weapon box ignore it
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair weapon:(Weapon *)weapon weaponBox:(Player *)weaponBox{
    if (weaponBox.parent == weapon.parent){
        return FALSE;
    }
    return FALSE;
}

//when  weapon node is true and weapon hits enemy remove enemy
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair weapon:(Weapon *)weapon enemy:(Enemy *)enemy{
    if(weaponFlag){
        if( weapon.parent.parent == enemy.parent){
            
            _hud.score +=multiplier*1000;
            [GameState sharedInstance].highScore = _hud.score;
            
            [enemy removeFromParent];
            CCParticleSystem *weaponCollision = (CCParticleSystem*)[CCBReader load:@"WeaponCollision"];
            weaponCollision.autoRemoveOnFinish = TRUE;
            weaponCollision.position = ccp(enemy.position.x, enemy.position.y +26);
            [weapon addChild:weaponCollision];
    
            [audio playEffect:@"explosion_medium_dirt_clusters.mp3"];
            enemiesKilledCount++;
            
            return TRUE;
        }
        else{
            return FALSE;
        }
    }
    else{
        return FALSE;
    }
    return FALSE;
}


//when weapon hits vehicals remove weapon
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair weapon:(Weapon *)weapon vehical:(Enemy *)vehical{
    if(weaponFlag){
        
        if (vehical.parent == weapon.parent.parent){
            [self weaponRemoval];
            CCParticleSystem *playerCollision = (CCParticleSystem*)[CCBReader load:@"Collision"];
            playerCollision.autoRemoveOnFinish = TRUE;
            playerCollision.position = ccp(vehical.position.x, vehical.position.y +26);
            [vehical addChild:playerCollision];
            
            
            return TRUE;
        }
        else{
            return FALSE;
        }
    }
    else{
        return FALSE;
    }
    return FALSE;
}

#pragma mark coffee powerup physics
-(BOOL) ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair powerUpCoffee:(PowerUps *)powerUpCoffee playerCollide:(Player *)playerCollide{
    if(playerCollide.parent == powerUpCoffee.parent){
        [powerUpCoffee removeFromParentAndCleanup:YES];
        
        _hud.score +=multiplier*2000;
        [GameState sharedInstance].highScore = _hud.score;
        
        powerUpsCollected++;
        [MGWU logEvent:@"Coffee_collected" withParams:nil];
        
        [self powerUpAction];
        return TRUE;
    }
    else{
        return FALSE;
    }
}
-(BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair powerUpCoffee:(PowerUps *)powerUpCoffee playerCollide:(Player *)playerCollide{
    if (playerCollide.parent != powerUpCoffee.parent) {
        return FALSE;
    }
}

-(BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair powerUpCoffee:(PowerUps *)powerUpCoffee weapon:(Weapon *)weapon{
    return FALSE;
}

#pragma mark heartPowerUp physics
-(BOOL) ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair heartPowerUp:(PowerUps *)heartPowerUp playerCollide:(Player *)playerCollide{
    if(playerCollide.parent == heartPowerUp.parent){
        [heartPowerUp removeFromParentAndCleanup:YES];
        
        _hud.score +=multiplier*(2000);
        [GameState sharedInstance].highScore = _hud.score;
        
        _greenNode.visible = TRUE;
        [playerCollide addHeart];
        
        [audio playEffect:@"classic_video_game_level_up.mp3"];
        
        powerUpsCollected++;
        [MGWU logEvent:@"heart_collected" withParams:nil];
        
        return TRUE;
    }
    else{
        return FALSE;
    }
}
-(BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair heartPowerUp:(PowerUps *)heartPowerUp playerCollide:(Player *)playerCollide{
    if (playerCollide.parent != heartPowerUp.parent) {
        return FALSE;
    }
}

-(BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair heartPowerUp:(PowerUps *)heartPowerUp weapon:(Weapon *)weapon{
    return FALSE;
}

-(BOOL) ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair xx:(PowerUps *)xx playerCollide:(Player *)playerCollide{
    if(playerCollide.parent == xx.parent){
        [xx removeFromParentAndCleanup:YES];
        
        multiplier ++;
        
        powerUpsCollected++;
        [MGWU logEvent:@"2x_collected" withParams:nil];
        
        return TRUE;
    }
    else{
        return FALSE;
    }
}
-(BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair xx:(PowerUps *)xx playerCollide:(Player *)playerCollide{
    if (playerCollide.parent != xx.parent) {
        return FALSE;
    }
}

-(BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair xx:(PowerUps *)xx weapon:(Weapon *)weapon{
    return FALSE;
}




@end
