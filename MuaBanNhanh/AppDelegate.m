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
#import "IndexHomePopupViewController.h"
#import "MBNProvinceManager.h"
#import "UIUnregisterHomePopup.h"
#import "IndexHomePopupViewController.h"
#import <FBSDKCoreKit.h>
#import <FBSDKLoginKit.h>

@interface AppDelegate ()

@property (strong, nonatomic) PKRevealController *revealController;
@property (strong, nonatomic) UINavigationController *rootNavigationController;

@property (strong, nonatomic) UIWindow *mainWindow;
@property (strong, nonatomic) UIWindow *popupWindow;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // popup window
    UIWindow *popupWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    popupWindow.windowLevel = UIWindowLevelNormal;
    self.popupWindow = popupWindow;
    
    [UIApplication sharedApplication].delegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.mainWindow = window;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
    UIViewController *homeContainerVC = [mainStoryBoard instantiateInitialViewController];
    UINavigationController *rootNavigationController = [[UINavigationController alloc] initWithRootViewController:homeContainerVC];
    [rootNavigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    rootNavigationController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Trở về" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.rootNavigationController = rootNavigationController;
    
    MBNSideMenuViewController *rearVC = [[MBNSideMenuViewController alloc] init];
    rearVC.view.backgroundColor = [UIColor greenColor];
    
    MBNRevealViewController *rootVC = [MBNRevealViewController revealControllerWithFrontViewController:rootNavigationController leftViewController:rearVC];
    if (!IS_IOS8_OR_ABOVE) {
        rootVC.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    window.rootViewController = rootVC;
    self.revealController = rootVC;
    
//    [[FLEXManager sharedManager] showExplorer];
    
    [window makeKeyAndVisible];
    
    MBNFloatButton *button = [[MBNFloatButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.floatButton = button;
    [self.revealController.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(80));
        make.height.equalTo(@(80));
        make.trailing.equalTo(button.superview).with.offset(-10);
        make.bottom.equalTo(button.superview).with.offset(-15);
    }];
    
    [window bringSubviewToFront:button];
    
    [window setNeedsUpdateConstraints];
    [window layoutIfNeeded];
    
    if(SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBackgroundColor:[UIColor colorFromHexString:@"#4CAF50"]];
    } else if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        // custom navigation bar
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorFromHexString:@"#4CAF50"]];
        [rootNavigationController.navigationBar setTranslucent:NO];
    } else {
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorFromHexString:@"#4CAF50"]];
        [[UINavigationBar appearance] setTranslucent:NO];
    }
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // white status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Override point for customization after application launch.
    
    [Crashlytics startWithAPIKey:@"75bef5bc8a8592cd4d35e170fef2575e8547d8dc"];
    
    [MBNProvinceManager getProvinces];
    [[MBNCategoryManager sharedProvider] getCategories:nil failure:nil];
    
    [FBSDKLoginButton class];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)displayPopupWindow {
    self.popupWindow.alpha = 0;
    self.popupWindow.hidden = NO;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    button.titleLabel.text = @"Kiss me";
    [button addTarget:self action:@selector(closePopupView) forControlEvents:UIControlEventTouchUpInside];
    
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"PlusPopups" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([IndexHomePopupViewController class])];
    
    self.popupWindow.rootViewController = vc;
    self.popupWindow.rootViewController.view.backgroundColor =[UIColor colorWithWhite:1.0 alpha:0.9];
    
    [self.popupWindow addSubview:self.floatButton];
    [self.popupWindow makeKeyWindow];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.floatButton.btnFloat.transform = CGAffineTransformRotate(self.floatButton.btnFloat.transform, M_PI*2 + M_PI * 3 / 4);
        
    } completion:nil];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.popupWindow.alpha = 1;
    }];
    
    UITapGestureRecognizer *tapToClose = [[UITapGestureRecognizer alloc] initWithTarget:self.floatButton action:@selector(openPopup:)];
    [self.popupWindow.rootViewController.view addGestureRecognizer:tapToClose];
    
    [self.floatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(80));
        make.height.equalTo(@(80));
        make.trailing.equalTo(self.floatButton.superview).with.offset(-10);
        make.bottom.equalTo(self.floatButton.superview).with.offset(-15);
    }];
    
    [self.popupWindow updateConstraintsIfNeeded];
    [self.popupWindow layoutIfNeeded];
}

- (void)closePopupView {
    [self closePopupViewCompletion:nil];
}

- (void)closePopupViewCompletion:(void (^)())completion {
    
    IndexHomePopupViewController *popup = (IndexHomePopupViewController *)self.popupWindow.rootViewController;
    
    [popup.popup dismissWithCompletion:^{
    }];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.floatButton.btnFloat.transform = CGAffineTransformRotate(self.floatButton.btnFloat.transform, -(M_PI*2 + M_PI * 3 / 4));
        
    } completion:nil];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         popup.backgroundView.alpha = 0;
                         popup.view.alpha = 0;
                     } completion:^(BOOL finished) {
                         self.popupWindow.alpha = 0;
                         popup.backgroundView.alpha = 0;
                         popup.view.alpha = 0;
                         [self.revealController.view addSubview:self.floatButton];
                         [self.revealController.view bringSubviewToFront:self.floatButton];
                         [self.floatButton mas_makeConstraints:^(MASConstraintMaker *make) {
                             make.width.equalTo(@(80));
                             make.height.equalTo(@(80));
                             make.trailing.equalTo(self.floatButton.superview).with.offset(-10);
                             make.bottom.equalTo(self.floatButton.superview).with.offset(-15);
                         }];
                         
                         [self.revealController.view updateConstraintsIfNeeded];
                         [self.revealController.view layoutIfNeeded];
    
                         [self.mainWindow makeKeyWindow];
                         if (completion) {
                             
                             completion();
                         }
                     }];
    
}

- (void)pushViewControllerToFrontViewController:(UIViewController *)viewController {
    [self.rootNavigationController pushViewController:viewController animated:YES];
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
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end
