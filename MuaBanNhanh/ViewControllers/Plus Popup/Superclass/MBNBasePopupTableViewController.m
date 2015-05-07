//
//  MBNBasePopupTableViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 5/6/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNBasePopupTableViewController.h"
#import "MBNShowLoginSegue.h"
#import "MBNNavigationViewController.h"
#import "AppDelegate.h"
#import "MBNCreateProductViewController.h"

@interface MBNBasePopupTableViewController ()

@end

@implementation MBNBasePopupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat animationDuration = 0.5;
    
    CGRect frame = cell.frame;
    CGRect desFrame = cell.frame;
    frame.origin = CGPointMake(0, tableView.height);
    cell.frame = frame;
    
    
    [UIView animateWithDuration:animationDuration delay:indexPath.row*0.05 usingSpringWithDamping:0.6 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        cell.frame = desFrame;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissWithCompletion:(void(^)(void))completion {
    
    NSInteger count = [self.tableView numberOfRowsInSection:0];
    
    for (int i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        CGFloat animationDuration = 0.2;
        
        CGRect frame = cell.frame;
        CGRect desFrame = cell.frame;
        desFrame.origin = CGPointMake(0, self.tableView.height);
        cell.frame = frame;
        
        
        [UIView animateWithDuration:animationDuration delay:indexPath.row*0.05 usingSpringWithDamping:0.6 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            cell.frame = desFrame;
            cell.alpha = 0;
            
        } completion:^(BOOL finished) {
            if (i == count - 1 && completion) {
                completion();
            }
        }];
    }
}

- (IBAction)onBtnHowTo:(id)sender {
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"CreateProduct" bundle:nil] instantiateInitialViewController];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.floatButton togglePopup:nil completion:^{
        MBNShowLoginSegue *segue = [[MBNShowLoginSegue alloc] initWithIdentifier:@"MBNLoginSegue" source:appDelegate.rootNavigationController destination:vc];
        [segue perform];
    }];
}

- (IBAction)onBtnLogin:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.floatButton togglePopup:nil completion:^{
        UIViewController *loginViewController = [[UIStoryboard storyboardWithName:@"UserLogin" bundle:nil] instantiateInitialViewController];
        MBNShowLoginSegue *segue = [[MBNShowLoginSegue alloc] initWithIdentifier:@"MBNLoginSegue" source:appDelegate.rootNavigationController destination:loginViewController];
        [segue perform];
    }];
}

- (IBAction)onBtnRegister:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UIViewController *loginViewController = [[UIStoryboard storyboardWithName:@"UserLogin" bundle:nil] instantiateViewControllerWithIdentifier:@"MBNRegisterViewController"];
    [appDelegate.floatButton togglePopup:nil completion:^{
        MBNNavigationViewController *navController = [[MBNNavigationViewController alloc] initWithRootViewController:loginViewController];
        MBNShowLoginSegue *segue = [[MBNShowLoginSegue alloc] initWithIdentifier:@"MBNLoginSegue" source:appDelegate.rootNavigationController destination:navController];
        [segue perform];
    }];
}

- (IBAction)onBtnSafeBuy:(id)sender {
    UIViewController *safeBuyViewController = [[UIStoryboard storyboardWithName:@"SafeBuyStoryboard" bundle:nil] instantiateInitialViewController];
    AppDelegate *appDelegate = APP_DELEGATE;
    [appDelegate.floatButton togglePopup:nil completion:^{
        [appDelegate.revealController presentViewController:safeBuyViewController animated:YES completion:nil];
    }];
}


@end
