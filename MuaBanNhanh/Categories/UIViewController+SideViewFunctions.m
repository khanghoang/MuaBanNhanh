//
//  UIViewController+SideViewFunctions.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/4/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "UIViewController+SideViewFunctions.h"
#import "AppDelegate.h"

@implementation UIViewController (SideViewFunctions)

- (void)mbn_toggleSideView {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    PKRevealController *revealController = appDelegate.revealController;
    [revealController showViewController:revealController.leftViewController];
    
    [appDelegate displayPopupWindow];
}

@end
