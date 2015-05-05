//
//  UIViewController+AddHambugerButton.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/4/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "UIViewController+AddHambugerButton.h"

@implementation UIViewController (AddHambugerButton)

- (void)mbn_addHambugerButton {
    UIBarButtonItem *hamburgerButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hamburger-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(mbn_toggleSideView)];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        hamburgerButton.tintColor = [UIColor whiteColor];
    }
    
    NSArray *arrLeftButtons = @[hamburgerButton];
    self.navigationItem.leftBarButtonItems = arrLeftButtons;
}

- (void)mbn_addSearchButton {
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavBarIconSearch_white"] style:UIBarButtonItemStylePlain target:self action:@selector(mbn_pushSearchProductVC)];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        searchButton.tintColor = [UIColor whiteColor];
    }
    
    self.navigationItem.rightBarButtonItem = searchButton;
}

@end
