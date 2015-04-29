//
//  MBNManageProductViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/29/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNManageProductViewController.h"
#import "MBNManageProductViewModel.h"
#import "MBNManageProductTypeViewController.h"

@interface MBNManageProductViewController ()

@property (strong, nonatomic) MBNManageProductViewModel *viewModel;

@end

@implementation MBNManageProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (MBNManageProductViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[MBNManageProductViewModel alloc] init];
    }
    
    return _viewModel;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MBNManageProductTypeViewController *typesVC = segue.destinationViewController;
    typesVC.viewModel = self.viewModel;
}

@end
