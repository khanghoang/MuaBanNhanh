//
//  MBNProductDetailsViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/25/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNProductDetailsViewController.h"
#import "MBNProductDetailsViewModel.h"

@interface MBNProductDetailsViewController ()

@property (strong, nonatomic) MBNProductDetailsViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UILabel *lblProductName;

@end

@implementation MBNProductDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewModel = [[MBNProductDetailsViewModel alloc] init];
}

- (void)loadProductDetailsAndObserver {
    [self.viewModel loadProductDetailsWithID:self.productID];
    
    RAC(self.lblProductName, text) = [RACObserve(self.viewModel, product) map:^id(MBNProduct *product) {
        return product.name;
    }];
}

@end
