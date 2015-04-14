//
//  AppDelegate.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 3/30/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder
<
UIApplicationDelegate
>

@property (strong, nonatomic) UIWindow *window;
@property (strong, readonly) PKRevealController *revealController;
@property (strong, readonly) UINavigationController *rootNavigationController;

@property (strong, readonly) UIWindow *mainWindow;
@property (strong, readonly) UIWindow *popupWindow;

- (void)displayPopupWindow;
- (void)closePopupViewCompletion:(void (^)())completion;

@end

