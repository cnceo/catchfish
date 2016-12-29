//
//  MyClass.m
//  iFruit
//
//  Created by mac on 11-7-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SoundUtils.h"


@implementation SoundUtils

static NSMutableDictionary *trackFiles;
static BOOL enabled_=TRUE;
//static BOOL musicVolume_=1.0f;


+(void) addMusicTrack:(NSString*)filename name:(NSString*)name {
    if (trackFiles == nil) {
        trackFiles = [[NSMutableDictionary alloc] init];
    }
    [trackFiles setObject:filename forKey:name];
}
//
//通过判断字典中是否为空，看有没有音频文件。
//
+ (BOOL)hasMusicTrack:(NSString*)name {
    id obj = [trackFiles objectForKey:name];
    if(obj==nil) return FALSE;
    else
        return TRUE;
}
//
//对上文提及的方法进行封装，参数是播放的名字，和是否重复播放
//
+ (void)playMusicTrack:(NSString*)name withRepeat:(BOOL)b {
#ifndef DEBUG_NO_SOUND
    if (!enabled_) return;
    if (trackFiles == nil) return;
    
//    if(track!=nil) {
//        @try {
//            [self stopCurrentTrack];
//        }
//        @catch (NSException* ex) {
//            NSLog([ex description]);
//        }
//    }
//    //
//    // 这个函数initWithPath就是上文提及的，初始化方法。
//    //
//    track = [[GBMusicTrack alloc] initWithPath:[[NSBundle mainBundle] 
//                                                pathForResource:[trackFiles objectForKey:name] 
//                                                ofType:@"mp3"]];
//    [track setRepeat:b];
//    [track setVolume:musicVolume_];
//    // 音乐的播放
//    //
//    [track play];
#endif
}




+ (void)playBackgroundMusic:(NSString *)filename volume:(float)volume flag:(int)musicCanPlay{
    bool musicOn = [[[NSUserDefaults standardUserDefaults]valueForKey:@"music"]boolValue];
    if (musicOn) {
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:filename];
    [SimpleAudioEngine sharedEngine].backgroundMusicVolume = volume;
    if(musicCanPlay==0)  [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
    }
}
+ (void)pauseBackgroundMusic:(int)musicCanPlay{
    if(musicCanPlay==1)  [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
}

+ (void)playEffect:(NSString *)filename volume:(float)volume{
     bool musicOn = [[[NSUserDefaults standardUserDefaults]valueForKey:@"music"]boolValue];
    if (musicOn) {
        [SimpleAudioEngine sharedEngine].effectsVolume = volume;
        [[SimpleAudioEngine sharedEngine] playEffect:filename];
    }
 
    
}

@end
