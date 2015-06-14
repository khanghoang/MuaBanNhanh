//
//  MBNForgetPasswordViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 6/15/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNForgetPasswordViewController.h"

@interface MBNForgetPasswordViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation MBNForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://muabannhanh.com/thanh-vien/quen-mat-khau-app?device=mobile"]]];
}

@end
