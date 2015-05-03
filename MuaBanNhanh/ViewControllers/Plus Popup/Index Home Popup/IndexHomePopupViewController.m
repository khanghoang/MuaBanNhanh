//
//  IndexHomePopupViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "IndexHomePopupViewController.h"

@interface IndexHomePopupViewController ()

@property (strong, nonatomic) UIUnregisterHomePopup *popup;

@end

@implementation IndexHomePopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // TODO: check vc
    self.popup = segue.destinationViewController;
}


@end
