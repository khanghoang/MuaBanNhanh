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
- (IBAction)onBtnHowTo:(id)sender {
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"CreateProduct" bundle:nil] instantiateInitialViewController];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate closePopupViewCompletion:^{
        MBNShowLoginSegue *segue = [[MBNShowLoginSegue alloc] initWithIdentifier:@"MBNLoginSegue" source:appDelegate.rootNavigationController destination:vc];
        [segue perform];
    }];
}

- (IBAction)onBtnLogin:(id)sender {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate closePopupViewCompletion:^{
        UIViewController *loginViewController = [[UIStoryboard storyboardWithName:@"UserLogin" bundle:nil] instantiateInitialViewController];
        MBNShowLoginSegue *segue = [[MBNShowLoginSegue alloc] initWithIdentifier:@"MBNLoginSegue" source:appDelegate.rootNavigationController destination:loginViewController];
        [segue perform];
    }];
}

- (IBAction)onBtnRegister:(id)sender {
    UIViewController *loginViewController = [[UIStoryboard storyboardWithName:@"UserLogin" bundle:nil] instantiateViewControllerWithIdentifier:@"MBNRegisterViewController"];
    MBNNavigationViewController *navController = [[MBNNavigationViewController alloc] initWithRootViewController:loginViewController];
    MBNShowLoginSegue *segue = [[MBNShowLoginSegue alloc] initWithIdentifier:@"MBNLoginSegue" source:self destination:navController];
    [segue perform];
}

- (IBAction)onBtnSafeBuy:(id)sender {
    UIViewController *safeBuyViewController = [[UIStoryboard storyboardWithName:@"SafeBuyStoryboard" bundle:nil] instantiateInitialViewController];
    AppDelegate *appDelegate = APP_DELEGATE;
    [appDelegate closePopupViewCompletion:^{
        [appDelegate.revealController presentViewController:safeBuyViewController animated:YES completion:nil];
    }];
}

@end
