//
//  AppDelegate.h
//  fish
//
//  Created by 海锋 周 on 12-4-11.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundUtils.h"
#import "Level.h"

@import GoogleMobileAds;

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate,GADInterstitialDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property(nonatomic, strong)Level *currentLevel;
@property (nonatomic, retain) UIWindow *window;
@property (retain, nonatomic) IBOutlet GADBannerView *vAd;
@property(nonatomic, strong) GADInterstitial *interstitial;

@end
