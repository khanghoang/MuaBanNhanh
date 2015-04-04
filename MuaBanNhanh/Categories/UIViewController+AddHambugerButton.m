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
    hamburgerButton.tintColor = [UIColor whiteColor];
    
    NSArray *arrLeftButtons = @[hamburgerButton];
    self.navigationItem.leftBarButtonItems = arrLeftButtons;
}

@end
