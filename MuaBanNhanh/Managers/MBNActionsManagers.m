//
//  MBNActionsManagers.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNActionsManagers.h"

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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", numberString]]];
}

@end
