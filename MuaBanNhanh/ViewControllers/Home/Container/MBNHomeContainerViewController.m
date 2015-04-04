//
//  MBNHomeContainerViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/1/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNHomeContainerViewController.h"

static const CGFloat NAVIGATION_BAR_TITLE_IMAGE_WIDTH = 140;

@interface MBNHomeContainerViewController ()

@end

@implementation MBNHomeContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - NAVIGATION_BAR_TITLE_IMAGE_WIDTH)/2, 8, NAVIGATION_BAR_TITLE_IMAGE_WIDTH, 25)];
    [titleView setImage:[UIImage imageNamed:@"logo"]];
    UIView *wrapperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [wrapperView addSubview:titleView];
    
    self.navigationItem.titleView = wrapperView;
}

@end
