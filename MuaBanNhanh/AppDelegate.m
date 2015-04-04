//
//  AppDelegate.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 3/30/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "AppDelegate.h"
#import "MBNRevealViewController.h"
#import "MBNHomeContainerViewController.h"

@interface AppDelegate ()

@property (strong, nonatomic) PKRevealController *revealController;
@property (strong, nonatomic) UINavigationController *rootNavigationController;

@property (strong, nonatomic) UIWindow *mainWindow;
@property (strong, nonatomic) UIWindow *popupWindow;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UIApplication sharedApplication].delegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.mainWindow = window;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
    UIViewController *homeContainerVC = [mainStoryBoard instantiateInitialViewController];
    UINavigationController *rootNavigationController = [[UINavigationController alloc] initWithRootViewController:homeContainerVC];
    self.rootNavigationController = rootNavigationController;
    
    MBNSideMenuViewController *rearVC = [[MBNSideMenuViewController alloc] init];
    rearVC.view.backgroundColor = [UIColor greenColor];
    
    MBNRevealViewController *rootVC = [MBNRevealViewController revealControllerWithFrontViewController:rootNavigationController leftViewController:rearVC];
    window.rootViewController = rootVC;
    self.revealController = rootVC;
    
    [[FLEXManager sharedManager] showExplorer];
    
    [window makeKeyWindow];
    
    if(SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBackgroundColor:[UIColor colorFromHexString:@"#1976D2"]];
    } else if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        // custom navigation bar
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorFromHexString:@"#1976D2"]];
        [rootNavigationController.navigationBar setTranslucent:NO];
    } else {
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorFromHexString:@"#1976D2"]];
        [[UINavigationBar appearance] setTranslucent:NO];
    }
    
    // Override point for customization after application launch.
    return YES;
}

- (void)displayPopupWindow {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor blueColor];
    window.windowLevel = UIWindowLevelAlert;
    self.popupWindow = window;
    window.alpha = 0;
    window.hidden = NO;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    button.titleLabel.text = @"Kiss me";
    [button addTarget:self action:@selector(closePopupView) forControlEvents:UIControlEventTouchUpInside];
    window.rootViewController = [[UIViewController alloc] init];
    window.rootViewController.view.backgroundColor = [UIColor whiteColor];
    
    [window makeKeyWindow];
    
    [UIView animateWithDuration:0.45 animations:^{
        window.alpha = 1;
    }];
    
    UITapGestureRecognizer *tapToClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopupView)];
    [window.rootViewController.view addGestureRecognizer:tapToClose];
}

- (void)closePopupView {
    [self.mainWindow makeKeyWindow];
    self.popupWindow.hidden = YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
