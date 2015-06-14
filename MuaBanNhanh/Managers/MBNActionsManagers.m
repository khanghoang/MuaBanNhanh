//
//  MBNActionsManagers.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNActionsManagers.h"
#import <MessageUI/MessageUI.h>

@interface MBNActionsManagers()
<
MFMessageComposeViewControllerDelegate
>

@end

@implementation MBNActionsManagers

+ (instancetype)sharedInstance
{
    static MBNActionsManagers *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MBNActionsManagers alloc] init];
    });

    return instance;
}

- (void)callNumber:(NSString *)numberString {
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [numberString stringByReplacingOccurrencesOfString:@" " withString:@""]]]];
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Thiết bị của bạn không có chức năng gọi điện" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notPermitted show];
    }
}

- (void)checkRequestErrorAndForceLogout:(NSDictionary *)responseObject {
    if([responseObject[@"status"] integerValue] == 400 && [[responseObject[@"message"] uppercaseString] containsString:@"TOKEN"] ) {
        [[MBNUserManager sharedProvider] logout];
        [SVProgressHUD showErrorWithStatus:@"Bạn đã đăng nhập tài khoản trên thiết bị khác!\nĐể tiếp tục sử dụng vui lòng Đăng nhập lại."
                                  maskType:SVProgressHUDMaskTypeGradient];
        AppDelegate *appDelegate = APP_DELEGATE;
        [appDelegate.rootNavigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)sendSMSToNumber:(NSString *)numberString {
    AppDelegate *appDelegate = APP_DELEGATE;
    [appDelegate.floatButton togglePopup:nil completion:nil];
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = @"";
        controller.recipients = [NSArray arrayWithObjects:numberString, nil];
        controller.messageComposeDelegate = self;
        [appDelegate.rootNavigationController presentViewController:controller animated:YES completion:nil];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
