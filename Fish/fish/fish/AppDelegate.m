//
//  AppDelegate.m
//  fish
//
//  Created by 海锋 周 on 12-4-11.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "GameConfig.h"
#import "HelloWorldLayer.h"
#import "MenuLayer.h"
#import "RootViewController.h"

@implementation AppDelegate

@synthesize window;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController

//	CC_ENABLE_DEFAULT_GL_STATES();
//	CCDirector *director = [CCDirector sharedDirector];
//	CGSize size = [director winSize];
//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
//	sprite.position = ccp(size.width/2, size.height/2);
//	sprite.rotation = -90;
//	[sprite visit];
//	[[director openGLView] swapBuffers];
//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}
- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
//	if( ! [director enableRetinaDisplay:YES] )
//		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:NO];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
    window.rootViewController = viewController;
//	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	
	// Removes the startup flicker
	[self removeStartupFlicker];
	
  
   
    
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"level"]) {
        _currentLevel = [[NSUserDefaults standardUserDefaults]objectForKey:@"level"];
    }else{
        _currentLevel =[[Level alloc]init];
        _currentLevel.level = 1;
        _currentLevel.levelSpeedFish = 2;
        _currentLevel.levelPoint = 300;
        _currentLevel.levelArrFish = [[NSMutableArray alloc]init];
        // dung duoc 1,2,3,4,5,6,7,8,9,13,14,18,12
        [_currentLevel.levelArrFish addObject:[NSNumber numberWithInt:1]];
        [_currentLevel.levelArrFish addObject:[NSNumber numberWithInt:7]];
        [_currentLevel.levelArrFish addObject:[NSNumber numberWithInt:12]];
        [_currentLevel.levelArrFish addObject:[NSNumber numberWithInt:6]];
        [_currentLevel.levelArrFish addObject:[NSNumber numberWithInt:14]];
        [_currentLevel.levelArrFish addObject:[NSNumber numberWithInt:8]];
        [_currentLevel.levelArrFish addObject:[NSNumber numberWithInt:13]];
        [_currentLevel.levelArrFish addObject:[NSNumber numberWithInt:5]];
    }
    
    //sound
    [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"music"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [SoundUtils playBackgroundMusic:BACKGROUNDMP3 volume:1 flag:1];
    
	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene: [MenuLayer scene]];
    
    
    //admob
    NSLog(@"screen width %f , screen height %f",self.window.frame.size.width,self.window.frame.size.height);
    
    _vAd = [[GADBannerView alloc]initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, ADMOB_HEIGHT)];
    [_vAd setBackgroundColor:[UIColor redColor]];
    _vAd.adUnitID = ADMOB_KEY;
    _vAd.rootViewController = self.window.rootViewController;
    GADRequest *request = [GADRequest request];
    [_vAd loadRequest:request];
    [self.window addSubview:_vAd];
    
     [self createAndLoadInterstitial];
     [self showAdmobBanner];
    
  
    
}
#pragma mark - addmob fullscreen
- (void)interstitial:(GADInterstitial *)interstitial
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"interstitialDidFailToReceiveAdWithError: %@", [error localizedDescription]);
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    NSLog(@"interstitialDidDismissScreen");
    [self createAndLoadInterstitial];
}

- (void)createAndLoadInterstitial {
    self.interstitial = [[GADInterstitial alloc] init];
    self.interstitial.adUnitID = ADMOB_FULLSCREEN_KEY;
    self.interstitial.delegate = self;
    
    GADRequest *request = [GADRequest request];
    [self.interstitial loadRequest:request];
}

- (void)showAdd {
    
    if (self.interstitial.isReady) {
      
    [self.interstitial presentFromRootViewController:viewController];
    }
    
}

- (void) hideAdmobBanner{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void) showAdmobBanner{
  
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(showAdd) withObject:self afterDelay:0.5];
  
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] end];
	[window release];
	[super dealloc];
}

@end
