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

@property (strong, nonatomic) MBNUser *user;

// 1st section
@property (weak, nonatomic) IBOutlet UITextField *lblPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *lblName;
@property (weak, nonatomic) IBOutlet UITextField *lblPassword;

// 2nd section
@property (weak, nonatomic) IBOutlet UITextField *lblIdentity;
@property (weak, nonatomic) IBOutlet UITextField *lblBirthday;
@property (weak, nonatomic) IBOutlet UITextField *lblPersonalEmail;

// 3rd section
@property (weak, nonatomic) IBOutlet UITextField *lblTradeName;
@property (weak, nonatomic) IBOutlet UITextView *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *lblCity;
@property (weak, nonatomic) IBOutlet UITextField *lblProvinde;
@property (weak, nonatomic) IBOutlet UITextField *lblBusinessModel;
@property (weak, nonatomic) IBOutlet UITextField *lblLicense;
@property (weak, nonatomic) IBOutlet UITextField *lblBusinessEmail;
@property (weak, nonatomic) IBOutlet UITextField *lblCreateAt;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintAddressHeight;

@end

@implementation MBNEditUserInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[MBNUserManager sharedProvider] getOwnInformation:^(MBNUser *user) {
        
        [self updateContentWithUser:user];
        
    } failure:^(NSString *errorString) {
        
    }];
}

- (void)updateContentWithUser:(MBNUser *)user {
    
    // 1st section
    self.lblPhoneNumber.text = user.phone;
    self.lblName.text = user.name;
    
    // 2nd section
    self.lblIdentity.text = user.identity;
//    self.lblBirthday.text = user.bir
    self.lblPersonalEmail.text = user.email;
    
    
    // 3rd section
    self.lblTradeName.text = user.name;
    self.txtAddress.text = user.address;
    self.lblBusinessEmail.text = user.email;
    
    NSDateFormatter *dateFormatter = [MBNUser sharedDateFormatter];
    self.lblCreateAt.text = [dateFormatter stringFromDate:user.createAt];
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
