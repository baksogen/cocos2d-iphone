//
// Mem Bug
// a cocos2d example
// http://www.cocos2d-iphone.org
//


#import "MemBug.h"

#pragma mark -
#pragma mark MemBug
@implementation Layer1
-(id) init
{
	if(!(self=[super init]))
        return nil;

    [self reset];
    
	return self;
}


-(void) reset {

	static int localtag = 0;
	localtag++;

    //[self check:self];

    MenuItem *item1 = [MenuItemFont itemFromString: @"One"
                                            target: self selector:@selector(menuCallback:)];
    MenuItem *item2 = [MenuItemFont itemFromString: @"Two"
                                            target: self selector:@selector(menuCallback:)];
    MenuItem *item3 = [MenuItemFont itemFromString: @"Three"
                                            target: self selector:@selector(menuCallback:)];
    MenuItem *item4 = [MenuItemFont itemFromString: @"Four"
                                            target: self selector:@selector(menuCallback:)];
    MenuItem *item5 = [MenuItemFont itemFromString: @"Five"
                                            target: self selector:@selector(menuCallback:)];
    MenuItem *item6 = [MenuItemFont itemFromString: @"Six"
                                            target: self selector:@selector(menuCallback:)];
    
    Menu *menu = [Menu menuWithItems: item1, item2, item3, item4, item5, item6, nil];
	[menu alignItemsVertically];
//    [menu alignItemsInColumns:[NSNumber numberWithInt:3], [NSNumber numberWithInt:3], nil];
    
    [self addChild: menu z:0 tag:localtag];
	
	[self removeChildByTag:localtag-1 cleanup:YES];

    //[self check:self];
}

-(void) check:(CocosNode *)t {

	NSArray *array = [t children];
    for (CocosNode *node in array) {
        NSLog(@"0x%x, rc: %d", node, [node retainCount]);
        [self check:node];
    }
}

-(void) menuCallback: (id) sender
{
	[self reset];
}

@end


// CLASS IMPLEMENTATIONS
@implementation AppController

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// must be called before any othe call to the director
//	[Director useFastDirector];
	
	// before creating any layer, set the landscape mode
	[[Director sharedDirector] setDeviceOrientation: CCDeviceOrientationLandscapeRight];

	// show FPS
	[[Director sharedDirector] setDisplayFPS:YES];

	// multiple touches or not ?
//	[[Director sharedDirector] setMultipleTouchEnabled:YES];
	
	// frames per second
	[[Director sharedDirector] setAnimationInterval:1.0/60];	

	// attach cocos2d to a window
	[[Director sharedDirector] attachInView:window];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[Texture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];	

	Scene *scene = [Scene node];

	[scene addChild:[Layer1 node] z:0];

	[window makeKeyAndVisible];
	[[Director sharedDirector] runWithScene: scene];
}

// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	[[Director sharedDirector] pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	[[Director sharedDirector] resume];
}

// purge memroy
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[TextureMgr sharedTextureMgr] removeAllTextures];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[Director sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
	[window dealloc];
	[super dealloc];
}

@end