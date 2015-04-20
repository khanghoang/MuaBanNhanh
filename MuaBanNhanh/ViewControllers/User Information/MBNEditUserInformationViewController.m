//
//  MBNEditUserInformationViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/18/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNEditUserInformationViewController.h"

@interface MBNEditUserInformationViewController ()
<
UITextViewDelegate
>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintAddressHeight;

@end

@implementation MBNEditUserInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[MBNUserManager sharedProvider] getOwnInformation:^(MBNUser *user) {
        
    } failure:^(NSString *errorString) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBtnLogout:(id)sender {
    [[MBNUserManager sharedProvider] logout];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Thông báo"
                                                        message:@"Bạn đã đăng xuất khỏi thiết bị"
                                                       delegate:nil
                                              cancelButtonTitle:@"Đồng ý" otherButtonTitles:nil];
    [alertView show];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.constraintAddressHeight.constant = textView.contentSize.height;
    [textView updateConstraintsIfNeeded];
    [textView layoutIfNeeded];
}

@end
