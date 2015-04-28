//
//  MBNHomeContainerViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/1/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "AppDelegate.h"
#import "MBNHomeContainerViewController.h"
#import "MBNCreateProductViewController.h"

static const CGFloat NAVIGATION_BAR_TITLE_IMAGE_WIDTH = 140;

@interface MBNHomeContainerViewController ()

@end

@implementation MBNHomeContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect frame = CGRectMake(
                              ([UIScreen mainScreen].bounds.size.width - NAVIGATION_BAR_TITLE_IMAGE_WIDTH)/2 - 60,
                              5,
                              NAVIGATION_BAR_TITLE_IMAGE_WIDTH,
                              25);
    
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:frame];
    [titleView setImage:[UIImage imageNamed:@"logo"]];
    UIView *wrapperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [wrapperView addSubview:titleView];
    
    self.navigationItem.titleView = wrapperView;
    
    [self mbn_addHambugerButton];
}

- (IBAction)openPopup:(id)sender {
//    TODO: Testing create product VC
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate displayPopupWindow];
}

@end
