//
//  MBNProductImagesViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/25/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNProductImagesViewController.h"
#import "MBNProductDetailsViewModel.h"

@interface MBNProductImagesViewController ()

@property (strong, nonatomic) MBNProductDetailsViewModel *viewModel;

@end

@implementation MBNProductImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewModel = [[MBNProductDetailsViewModel alloc] init];
}

@end
