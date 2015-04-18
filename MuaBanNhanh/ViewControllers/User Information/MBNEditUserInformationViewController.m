//
//  MBNEditUserInformationViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/18/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNEditUserInformationViewController.h"

@interface MBNEditUserInformationViewController ()

@end

@implementation MBNEditUserInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onBtnLogout:(id)sender {
    [[MBNUserManager sharedProvider] logout];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Thông báo"
                                                        message:@"Bạn đã đăng xuất khỏi thiết bị"
                                                       delegate:nil
                                              cancelButtonTitle:@"Đồng ý" otherButtonTitles:nil];
    [alertView show];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
