//
//  MBNRegisterViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/13/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNRegisterViewController.h"

@interface MBNRegisterViewController ()
<
UIGestureRecognizerDelegate
>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) UITextField *activeField;

@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtRePassword;
@property (weak, nonatomic) IBOutlet UIButton *btnAgree;

@end

@implementation MBNRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self registerForKeyboardNotifications];
}

- (NSString *)getTheFormStatus {
    
    if([self.txtFirstName.text isEqualToString:@""]) {
        return @"Bạn chưa điền họ và tên đệm";
    }
    
    if([self.txtName.text isEqualToString:@""]) {
        return @"Bạn chưa điền tên";
    }
    
    if([self.txtPhone.text isEqualToString:@""]) {
        return @"Bạn chưa điền số điện thoai";
    }
    
    if([self.txtPassword.text isEqualToString:@""]) {
        return @"Bạn chưa nhập mật khẩu";
    }
    
    if(![self.txtPassword.text isEqualToString:self.txtRePassword.text]) {
        return @"Mật khẩu nhập lại không khớp";
    }
    
    if (!self.btnAgree.isSelected) {
        return @"Bạn chưa đồng ý với điều khoản sử dụng";
    }
    
    return @"";
}

- (BOOL)isTheFormValidated {
    NSString *errorString = [self getTheFormStatus];
    if(![errorString isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Lỗi"
                                                            message:errorString
                                                           delegate:nil cancelButtonTitle:@"Đồng ý"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        return NO;
    }
    
    return YES;
}

- (IBAction)onBtnRegister:(id)sender {
    [self isTheFormValidated];
}

#pragma marks - Keyboard

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    }];
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}

#pragma marks - Outlets button actions

- (IBAction)onTapOutside:(id)sender {
    self.activeField = nil;
    [self.view endEditing:YES];
}

- (IBAction)onCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTapCheckbox:(id)sender {
    UIButton *btnCheckbox = (UIButton *)sender;
    btnCheckbox.selected = !btnCheckbox.selected;
}

@end
