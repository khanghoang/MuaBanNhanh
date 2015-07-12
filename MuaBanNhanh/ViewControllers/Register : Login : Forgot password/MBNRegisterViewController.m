//
//  MBNRegisterViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/13/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNRegisterViewController.h"
#import "MBNUserManager.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>

@interface MBNRegisterViewController ()
<
UIGestureRecognizerDelegate,
TTTAttributedLabelDelegate
>
@property (weak, nonatomic) IBOutlet UIWebView *webview;


@end

@implementation MBNRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://muabannhanh.com/thanh-vien/dang-ky-app"]]];
    
}

- (IBAction)onCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
