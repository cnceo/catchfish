//
//  HelloWorldLayer.m
//  fish
//
//  Created by 海锋 周 on 12-4-11.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "MenuLayer.h"
#import "GameOverLayer.h"
#import "AppDelegate.h"
// HelloWorldLayer implementation
@implementation HelloWorldLayer

#define WINHEIGHT 1024
#define WINWIDHT  768
#define MAX_ENEMY 15
#define MOVESPEED 5

#define KProgressTag 100


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	if( (self=[super init])) {
        
        
        Energy = 0;
        maxEnergy = 1000;
        
		self.isTouchEnabled = YES;
        
        [self LoadTexture];
        
        [self initUITab];
        
        srand(time(NULL));
       
        while ([[fishSheet children]count]<MAX_ENEMY)
        {
            [self addFish];
        }
        [self schedule:@selector(updateGame:) interval:0.05];
        
     
        
    }
    
	return self;
}

-(void) LoadTexture
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CCSprite *bg = [CCSprite spriteWithFile:@"bj01.jpg"];   
    bg.position = ccp(screenSize.width/2, screenSize.height/2);
    bg.anchorPoint = CGPointMake(0.5, 0.5);
    [self addChild:bg];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"fish.plist"];
    fishSheet = [CCSpriteBatchNode batchNodeWithFile:@"fish.png"];
    [self addChild:fishSheet];

    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"seamaid.plist"];
    seaMaid = [CCSpriteBatchNode batchNodeWithFile:@"seamaid.png"];
    [self addChild:seaMaid];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"fish2.plist"];
    bulletSheet = [CCSpriteBatchNode batchNodeWithFile:@"fish2.png"];
    [self addChild:bulletSheet];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"fish3.plist"];
    netSheet = [CCSpriteBatchNode batchNodeWithFile:@"fish3.png"];
    [self addChild:netSheet];
}


-(void) initUITab
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    CCSprite *engryBox =[CCSprite spriteWithFile:@"ui_2p_004.png"];
    engryBox.anchorPoint = ccp(0.5, 0.5);
    engryBox.position = ccp(520,30);
    [self addChild:engryBox];
    
    engryPointer =[CCSprite spriteWithFile:@"ui_2p_005.png"];
    engryPointer.position = ccp(520,30);
    [self addChild:engryPointer];
    
    
    CCSprite *bgExp =[CCSprite spriteWithFile:@"ui_box_01.png"];
    bgExp.position = ccp(500, screenSize.height - ADMOB_HEIGHT  );
    bgExp.anchorPoint = CGPointMake(0.5, 1);
    [self addChild:bgExp];
    
    CCSprite *bgNum =[CCSprite spriteWithFile:@"ui_box_02.png"];
    bgNum.position = ccp(440, 90);
    [self addChild:bgNum];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cannon.plist"];
    cannonSheet = [CCSpriteBatchNode batchNodeWithFile:@"cannon.png"];
    [self addChild:cannonSheet];
    
    score1 = [[UIRollNum alloc]init];
    [score1 setNumber:10];
    [score1 setPosition:ccp(365, 17)];
    [self addChild:score1 z:100];
    
    gun = [CCSprite spriteWithSpriteFrameName:@"actor_cannon1_71.png"];
    gun.position = ccp(520, 50);
    [cannonSheet addChild:gun];
    

//     CCProgressTimer *ct=[CCProgressTimer progressWithFile:@"time.png"];
//     ct.position=ccp(100 , screenSize.height/2 - ADMOB_HEIGHT);
//     ct.anchorPoint = CGPointMake(0.5, 1);
//     ct.percentage=0;
//     ct.type=kCCProgressTimerTypeHorizontalBarLR;
//     [self addChild:ct z:10 tag:KProgressTag];  
    
}

/**************************************************
 scheduleUpdate 的回调函数
 *************************************************/
-(void) updateGame:(ccTime)delta
{
    CCFish *sprite;
    CCNet *net;
    CCScaleTo* scale0 = [CCScaleTo actionWithDuration:0.3 scale:1.1];
    CCScaleTo* scale1 = [CCScaleTo actionWithDuration:0.3 scale:0.9];
    
    CCScaleTo* scale2 = [CCScaleTo actionWithDuration:0.3 scale:4.1];
    CCScaleTo* scale3 = [CCScaleTo actionWithDuration:0.3 scale:0.9];
    
    //fish
    CCARRAY_FOREACH([fishSheet children], sprite)
	{
        
        if ([sprite isCatch]) {
            continue;
        }
       
         CCARRAY_FOREACH([bulletSheet children],net)
        {
            
              
            if (CGRectContainsPoint(sprite.boundingBox, net.position)) {
             
                if (![sprite randomCatch:sprite.tag]) 
                {
                    net.isCatching = NO;
                    break;
                }else{
                    net.isCatching = NO;
                    sprite.isCatch = YES;
                    [SoundUtils playEffect:@"getfruit.caf" volume:1];
                    NSMutableArray *fishi01 = [NSMutableArray array];
                    for(int i = 1; i <3; i++)
                    {
                        if (sprite.tag<10) {
                            [fishi01 addObject:
                             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                              [NSString stringWithFormat:@"fish0%d_catch_0%d.png",sprite.tag,i]]];
                        }else{
                            [fishi01 addObject:
                             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                              [NSString stringWithFormat:@"fish%d_catch_0%d.png",sprite.tag,i]]];
                        }
                        
                    }
                    
                    CCActionInterval *fish01_catch_act = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:fishi01 delay:0.2f]  restoreOriginalFrame:NO]times:2];
                    
                    CCSequence* fishSequence = [CCSequence actions:fish01_catch_act,[CCCallFuncO actionWithTarget:self selector:@selector(afterCatch:) object:sprite], nil];
                    
                    [sprite stopAllActions];
                    [sprite runAction:fishSequence];
                    
                    NSString *numGold = [NSString stringWithFormat:@"+%d.png",sprite.tag%10];
                    CCSprite *gold = [CCSprite spriteWithFile:numGold];
                    gold.position =  sprite.position;
//                    [self showGold:sprite.tag atPosition:sprite.position];
                    
                 
                    
                    
                    CCSequence* goldSequence = [CCSequence actions:scale2, scale3, scale2, scale3,[CCCallFuncO actionWithTarget:self selector:@selector(afterShow:) object:gold], nil];
                    [gold runAction:goldSequence];
                    [self addChild:gold];
                    
                     [score1 setNumber:([score1 getNumber]+ sprite.tag%10)];
                  
                }
            }
            
            
        }
              
	}


    
    CCARRAY_FOREACH([seaMaid children], sprite)
    {
        
        if ([sprite isCatch]) {
            continue;
        }
       
        CCARRAY_FOREACH([bulletSheet children],net)
        {
            
            
            if (CGRectContainsPoint(sprite.boundingBox, net.position)) {
                
                if (![sprite randomCatch:sprite.tag])
                {
                    net.isCatching = NO;
                    break;
                }else{
                    net.isCatching = NO;
                    sprite.isCatch = YES;
                    [SoundUtils playEffect:@"getfruit.caf" volume:1];
                    NSMutableArray *fishi01 = [NSMutableArray array];
                    for(int i = 1; i <3; i++)
                    {
                        if (sprite.tag<10) {
                            [fishi01 addObject:
                             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                              [NSString stringWithFormat:@"fish0%d_catch_0%d.png",sprite.tag,i]]];
                        }else{
                            [fishi01 addObject:
                             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                              [NSString stringWithFormat:@"fish%d_catch_0%d.png",sprite.tag,i]]];
                        }
                        
                    }
                    
                    CCActionInterval *fish01_catch_act = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:fishi01 delay:0.2f]  restoreOriginalFrame:NO]times:2];
                    
                    CCSequence* fishSequence = [CCSequence actions:fish01_catch_act,[CCCallFuncO actionWithTarget:self selector:@selector(afterCatch:) object:sprite], nil];
                    
                    [sprite stopAllActions];
                    [sprite runAction:fishSequence];
                    
                    NSString *numGold = [NSString stringWithFormat:@"+%d.png",sprite.tag%10];
                    CCSprite *gold = [CCSprite spriteWithFile:numGold];
                    gold.position =  sprite.position;
                    //                    [self showGold:sprite.tag atPosition:sprite.position];
                    
                    
                    
                    
                    CCSequence* goldSequence = [CCSequence actions:scale2, scale3, scale2, scale3,[CCCallFuncO actionWithTarget:self selector:@selector(afterShow:) object:gold], nil];
                    [gold runAction:goldSequence];
                    [self addChild:gold];
                    
                    [score1 setNumber:([score1 getNumber]+ sprite.tag%10)];
                    
                }
            }
            
            
        }
        
    }
    
    CCARRAY_FOREACH([bulletSheet children],net)
    {
        if ([net isCatching]) {
            continue;
        } 

        [bulletSheet removeChild:net cleanup:NO];
    
        CCNet *tapnet = [CCNet spriteWithSpriteFrameName:@"net01.png"];
        tapnet.position = net.position;
        CCSequence* netSequence = [CCSequence actions:scale0, scale1, scale0, scale1,[CCCallFuncO actionWithTarget:self selector:@selector(afterShowNet:) object:tapnet], nil];
    
        [tapnet runAction:netSequence];
        [netSheet addChild:tapnet];                    
    
//        [score1 setNumber:([score1 getNumber]+5)];
    
    
    }
    
    
    while ([[fishSheet children]count]<MAX_ENEMY)
    {
        [self addFish];
    }
    
    if([self checkLose])
    {
        [self ShowLoseScreen];
    }
    
    if ([self checkPastLevel]) {
        [self ShowPastLevelScreen];
    }
	
}

-(BOOL)checkPastLevel
{
    if ([score1 getNumber] >= APP_DELEGATE.currentLevel.levelPoint) {
        
        return true;
    }
    return false;
}

- (void)ShowPastLevelScreen
{
  
}

- (void)ShowLoseScreen
{
//    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameOverLayer scene]]];
//      [[CCDirector sharedDirector] pushScene:[GameOverLayer scene]];
    
//    CGSize screenSize = [[CCDirector sharedDirector] winSize];
//    CCLabelTTF* gameOver = [CCLabelTTF labelWithString:NSLocalizedString(@"GAME OVER", @"GAME OVER") fontName:NSLocalizedString(@"Helvetica", @"Helvetica")  fontSize:60];
//    gameOver.position = CGPointMake(screenSize.width / 2, screenSize.height / 3);
//    [self addChild:gameOver z:100 tag:100];
//    CCTintTo* tint1 = [CCTintTo actionWithDuration:2 red:255 green:0 blue:0];
//    CCTintTo* tint2 = [CCTintTo actionWithDuration:2 red:255 green:255 blue:0];
//    CCTintTo* tint3 = [CCTintTo actionWithDuration:2 red:0 green:255 blue:0];
//    CCTintTo* tint4 = [CCTintTo actionWithDuration:2 red:0 green:255 blue:255];
//    CCTintTo* tint5 = [CCTintTo actionWithDuration:2 red:0 green:0 blue:255];
//    CCTintTo* tint6 = [CCTintTo actionWithDuration:2 red:255 green:0 blue:255];
//    CCSequence* tintSequence = [CCSequence actions:tint1, tint2, tint3, tint4, tint5, tint6, nil];
//    CCRepeatForever* repeatTint = [CCRepeatForever actionWithAction:tintSequence];
//    [gameOver runAction:repeatTint];
//    
//    CCRotateTo* rotate1 = [CCRotateTo actionWithDuration:2 angle:3];
//    CCEaseBounceInOut* bounce1 = [CCEaseBounceInOut actionWithAction:rotate1];
//    CCRotateTo* rotate2 = [CCRotateTo actionWithDuration:2 angle:-3];
//    CCEaseBounceInOut* bounce2 = [CCEaseBounceInOut actionWithAction:rotate2];
//    CCSequence* rotateSequence = [CCSequence actions:bounce1, bounce2, nil];
//    CCRepeatForever* repeatBounce = [CCRepeatForever actionWithAction:rotateSequence];
//    [gameOver runAction:repeatBounce];
//    
//    CCJumpBy* jump = [CCJumpBy actionWithDuration:3 position:CGPointZero height:screenSize.height / 3 jumps:1];
//    CCRepeatForever* repeatJump = [CCRepeatForever actionWithAction:jump];
//    [gameOver runAction:repeatJump];
//    
//    CCLabelTTF* touch = [CCLabelTTF labelWithString: NSLocalizedString(@"tap screen to play again",@"tap screen to play again")  fontName:NSLocalizedString(@"Helvetica", @"Helvetica")  fontSize:20];
//    touch.position = CGPointMake(screenSize.width / 2, screenSize.height / 4);
//    [self addChild:touch z:100 tag:101];
//    
//    CCBlink* blink = [CCBlink actionWithDuration:10 blinks:20];
//    CCRepeatForever* repeatBlink = [CCRepeatForever actionWithAction:blink];
//    [touch runAction:repeatBlink];
    
}

-(BOOL)checkLose
{
    if ([score1 getNumber]<= 0) {
        [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithInt:[score1 getNumber]] forKey:@"money"];
        return true;
    }
    return false;
}

-(void)showGold:(int)num atPosition:(CGPoint)pos
{
    CCLabelTTF* gameOver = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"+%d",num] fontName:NSLocalizedString(@"FONT NAME", @"FONT NAME")  fontSize:60];
    gameOver.position = pos;
    [self addChild:gameOver z:100 tag:100];
    gameOver.color = ccORANGE;

   
    
    CCRotateTo* rotate1 = [CCRotateTo actionWithDuration:2 angle:3];
    CCEaseBounceInOut* bounce1 = [CCEaseBounceInOut actionWithAction:rotate1];
    CCRotateTo* rotate2 = [CCRotateTo actionWithDuration:2 angle:-3];
    CCEaseBounceInOut* bounce2 = [CCEaseBounceInOut actionWithAction:rotate2];
//    CCSequence* rotateSequence = [CCSequence actions:bounce1, bounce2, nil];
//    CCRepeatForever* repeatBounce = [CCRepeatForever actionWithAction:rotateSequence];
//    [gameOver runAction:repeatBounce];
    
//    CCJumpBy* jump = [CCJumpBy actionWithDuration:3 position:CGPointZero height:pos.y + 20 jumps:1];
//    CCRepeatForever* repeatJump = [CCRepeatForever actionWithAction:jump];
//    [gameOver runAction:repeatJump];
    
    
//    CCSequence* goldSequence = [CCSequence actions:rotateSequence, jump,[CCCallFuncO actionWithTarget:self selector:@selector(afterShow:) object:gameOver], nil];
//    [gameOver runAction:goldSequence];
}

-(void) updateEnergry:(int) en
{
    Energy += en;
    if (Energy>=maxEnergy) {
        Energy = maxEnergy;
    }
    float rotation = 180.0 * Energy/maxEnergy;
    engryPointer.rotation  = rotation;
}

-(void) addFish
{
    
       int ran = rand()%8;
    
     int type = [[APP_DELEGATE.currentLevel.levelArrFish objectAtIndex:ran]intValue];
//    int type = 18;
        NSMutableArray *fishi01 = [NSMutableArray array];
        for(int i = 1; i <10; i++) {
            if(type <10){
                [fishi01 addObject:
                 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                  [NSString stringWithFormat:@"fish0%d_0%d.png",type,i]]];
            }else{
                [fishi01 addObject:
                 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                  [NSString stringWithFormat:@"fish%d_0%d.png",type,i]]];
            }
            
        }
        
        fish01_act = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:fishi01 delay:0.2f] restoreOriginalFrame:YES]];
   
    
//    CCFish *fish ;
//    = [CCFish spriteWithSpriteFrameName: [NSString stringWithFormat:@"fish0%d_0%d.png",type,1]];
      if(type <10){
          CCFish *fish = [CCFish spriteWithSpriteFrameName: [NSString stringWithFormat:@"fish0%d_0%d.png",type,1]];
          fish.speed = APP_DELEGATE.currentLevel.levelSpeedFish;
          fish.scale = 1.2f;
          fish.tag = type;
          fish.isCatch = NO;
          [fish runAction:fish01_act];
          [fish addPath];
          [fishSheet addChild:fish];
      }else{
          CCFish *fish = [CCFish spriteWithSpriteFrameName: [NSString stringWithFormat:@"fish%d_0%d.png",type,1]];
          fish.speed = APP_DELEGATE.currentLevel.levelSpeedFish;
          fish.scale = 1.2f;
          fish.tag = type;
          fish.isCatch = NO;
          [fish runAction:fish01_act];
          [fish addPath];
          if (type == 13 || type == 14) {
              
              [fishSheet addChild:fish];
          }else if (type == 12 || type == 11){
              [seaMaid addChild:fish];
          }
      }
    
    
}


-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint pos = [touch locationInView:touch.view];
		pos = [[CCDirector sharedDirector] convertToGL:pos];
        [gun setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"actor_cannon1_72.png"]];
        
        float angle = (pos.y - gun.position.y)/(pos.x-gun.position.x);
        angle = atanf(angle)/M_PI*180;
        if (angle<0) {
              gun.rotation = -(90+angle);
        }else if (angle>0)
        {
              gun.rotation = 90 - angle;
        }
    }
    [SoundUtils playEffect:@"click.caf" volume:1];
    
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        [gun setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"actor_cannon1_71.png"]];
        CGPoint pos = [touch locationInView:touch.view];
		pos = [[CCDirector sharedDirector] convertToGL:pos];
        
//        [score1 setNumber:([score1 getNumber]-rand()%20-2)];
         [score1 setNumber:([score1 getNumber]- 2)];
      
        CCNet *labelboard = [CCNet spriteWithSpriteFrameName:@"bullet01.png"];
        labelboard.position = ccp(512, 50);
        labelboard.isCatching = YES;
        CCMoveTo *move = [CCMoveTo actionWithDuration:1.0 position:pos];
        
        CCSequence* netSequence = [CCSequence actions:move,[CCCallFuncO actionWithTarget:self selector:@selector(ShowNet:) object:labelboard], nil];
        
        labelboard.rotation = gun.rotation;
        [labelboard runAction:netSequence];
        [bulletSheet addChild:labelboard];
        
        
        [self updateEnergry:rand()%20];
    }
}

-(void) ShowNet:(id)sender
{
    CCSprite *sp = sender;
 
    [bulletSheet removeChild:sp cleanup:NO];
    
    [sp setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"net01.png"]];
 
    
    CCScaleTo* scale0 = [CCScaleTo actionWithDuration:0.3 scale:1.1];
    CCScaleTo* scale1 = [CCScaleTo actionWithDuration:0.3 scale:0.9];
    
    CCSequence* netSequence = [CCSequence actions:scale0, scale1, scale0, scale1,[CCCallFuncO actionWithTarget:self selector:@selector(afterShowNet:) object:sp], nil];
    
    [sp runAction:netSequence];
    [netSheet addChild:sp];
}

-(void) afterShowNet:(id)sender
{
    CCSprite *sp = sender;
    [netSheet removeChild:sp cleanup:NO];
}

-(void) afterShow:(id)sender
{
//    [SoundUtils playEffect:@"getscore.caf" volume:1];
    CCSprite *sp = sender;
    [self removeChild:sp cleanup:NO];
}

-(void) afterCatch:(id)sender
{       
    CCSprite *sp = sender;
    [sp removeFromParentAndCleanup:YES];
//    [fishSheet removeChild:sp cleanup:NO];
}



// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
