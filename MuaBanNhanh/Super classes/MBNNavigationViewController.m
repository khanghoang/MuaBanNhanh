//
//  MBNNavigationViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/11/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNNavigationViewController.h"

@interface MBNNavigationViewController ()

@end

@implementation MBNNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [self.navigationBar setTranslucent:NO];
}

@end
