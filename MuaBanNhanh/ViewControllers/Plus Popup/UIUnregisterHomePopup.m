//
//  UIUnregisterHomePopup.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/10/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "UIUnregisterHomePopup.h"
#import "MBNShowLoginSegue.h"
#import "MBNNavigationViewController.h"
#import "AppDelegate.h"
#import "MBNCreateProductViewController.h"

@interface UIUnregisterHomePopup ()
<
MBNFloatButtonPopup
>

@end

@implementation UIUnregisterHomePopup

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (CGFloat)getViewHeight {
    return 164;
}



@end
