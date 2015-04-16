//
//  MBNLoginViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/11/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNLoginViewController.h"

@interface MBNLoginViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) UITextField *activeField;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end

@implementation MBNLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self registerForKeyboardNotifications];
}

- (NSString *)getErrorStringFromLoginForm {
    if([self.txtPhone.text isEqualToString:@""]) {
        return @"Bạn chưa điền số điện thoại";
    }
    
    if([self.txtPassword.text isEqualToString:@""]) {
        return @"Bạn chưa điền mật khẩu";
    }
    
    return @"";
}

- (BOOL)validateLoginForm {
    NSString *errorString = [self getErrorStringFromLoginForm];
    if([errorString isEqualToString:@""]) {
        return YES;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Lỗi"
                                                        message:errorString
                                                       delegate:nil
                                              cancelButtonTitle:@"Đồng ý"
                                              otherButtonTitles:nil];
    [alertView show];
    return NO;
}

- (IBAction)onBtnLogin:(id)sender {
    BOOL valid = [self validateLoginForm];
    if (!valid) {
        return;
    }
    
    [SVProgressHUD showWithStatus:@"Đang đăng nhập..."];
    
    [[MBNUserManager sharedProvider] loginWithPhone:self.txtPhone.text andPassword:self.txtPassword.text successBlock:^(NSDictionary *result) {
        
    } andFailure:^(NSError *error) {
        
    }];
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

- (IBAction)onBtnClose:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tapOutsideToDismissKeyboard:(id)sender {
    self.activeField = nil;
    [self.view endEditing:YES];
}

@end
