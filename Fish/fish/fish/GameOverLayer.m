//
//  SysMenu.m
//  G03
//
//  Created by Mac Admin on 15/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameOverLayer.h"
#import "HelloWorldLayer.h"


@implementation GameOverLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameOverLayer *layer = [GameOverLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init{
	self = [super init];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    

   
    
    
    
	return self;
}

-(void) review:(id)sender {
    [[UIApplication sharedApplication] openURL:
     [NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=984791635"]];
}

-(void) task :(id)sender {
    //[SceneManager pushEarn];
}

- (void)onNewGame:(id)sender{

    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:[HelloWorldLayer scene]]];
  
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
- (void)soundControll:(id)sender{
//    if(soundCanPlay==1){
//        soundCanPlay = 0;
//    }else{
//        soundCanPlay = 1;
//    }
//    [CommUtils setGameValue:@"soundCanPlay" value:[NSNumber numberWithInt:soundCanPlay]];
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
