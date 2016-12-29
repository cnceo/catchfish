//
//  SysMenu.m
//  G03
//
//  Created by Mac Admin on 15/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MenuLayer.h"
#import "HelloWorldLayer.h"

@implementation MenuLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLayer *layer = [MenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init{
	self = [super init];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    

   
    
    CCSprite* normal = [CCSprite spriteWithFile:@"play_button.png"];
    CCSprite* selected = [CCSprite spriteWithFile:@"play_button_click.png"];
    CCMenuItemSprite* item = [CCMenuItemSprite itemFromNormalSprite:normal selectedSprite:selected target:self selector:@selector(onNewGame:)];
//    [CCMenuItemSprite itemWithNormalSprite:normal selectedSprite:selected
//                                                              target:self selector:@selector(onNewGame:)];
    item.position = ccp(0, -128);
    


    
    CCMenuItemImage *musicOnItem = [CCMenuItemImage itemFromNormalImage:@"music_on.png" selectedImage:@"music_on.png"];

    CCMenuItemImage *musicOffItem = [CCMenuItemImage itemFromNormalImage:@"music_off.png" selectedImage:@"music_off.png"];
    
    CCMenuItemToggle* musicItem = [CCMenuItemToggle itemWithTarget:self selector:@selector(musicControll:) items:musicOnItem, musicOffItem, nil];
    
    //　当前状态是否播放背景音乐
    musicItem.selectedIndex = musicCanPlay==1?0:1;
    musicItem.position = ccp(84,0);

    
    CCLabelTTF *readme = [CCLabelTTF labelWithString:@"Drag the entire row, column, or swap pairs fruit to create the line of the three identical fruits to eliminate, you can also use help tools" dimensions:CGSizeMake(600,150) alignment:UITextAlignmentCenter fontName:@"Arial" fontSize:22];
    readme.position = ccp(size.width/2, 10);
    [self addChild:readme];
    
    // 创建菜单
    CCMenu* menu = [CCMenu menuWithItems: item,musicItem, nil];
        menu.position = CGPointMake(size.width/2, 428);
   

    [self addChild:menu];
    
    
    self.isTouchEnabled = YES;
    
	return self;
}

-(void) review:(id)sender {
    [[UIApplication sharedApplication] openURL:
     [NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=984791635"]];
}

- (void)onNewGame:(id)sender{

    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:[HelloWorldLayer scene]]];
   //[SceneManager goPlay];
    //[SceneManager goBowFruit];
}

- (void)musicControll:(id)sender{
//    if(musicCanPlay==1){
//        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
//        musicCanPlay = 0;
//    }else{
//        [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
//        musicCanPlay = 1;
//    }
//    [CommUtils setGameValue:@"musicCanPlay" value:[NSNumber numberWithInt:musicCanPlay]];
}


- (void)howToPlay:(id)sender {
//    AlertLayer *alertLayer = [AlertLayer node];
//    [self addChild:alertLayer];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"begin touch");
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
     NSLog(@"move touch");
}
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
     NSLog(@"end touch");
}

@end
