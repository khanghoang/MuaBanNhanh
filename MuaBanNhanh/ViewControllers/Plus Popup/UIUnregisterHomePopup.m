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

@interface UIUnregisterHomePopup ()

@end

@implementation UIUnregisterHomePopup

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBtnLogin:(id)sender {
    UIViewController *loginViewController = [[UIStoryboard storyboardWithName:@"UserLogin" bundle:nil] instantiateInitialViewController];
    MBNShowLoginSegue *segue = [[MBNShowLoginSegue alloc] initWithIdentifier:@"MBNLoginSegue" source:self destination:loginViewController];
    [segue perform];
}

- (IBAction)onBtnRegister:(id)sender {
    UIViewController *loginViewController = [[UIStoryboard storyboardWithName:@"UserLogin" bundle:nil] instantiateViewControllerWithIdentifier:@"MBNRegisterViewController"];
    MBNNavigationViewController *navController = [[MBNNavigationViewController alloc] initWithRootViewController:loginViewController];
    MBNShowLoginSegue *segue = [[MBNShowLoginSegue alloc] initWithIdentifier:@"MBNLoginSegue" source:self destination:navController];
    [segue perform];
}


@end
