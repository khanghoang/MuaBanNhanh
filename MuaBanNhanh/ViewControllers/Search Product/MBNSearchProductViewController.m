//
//  MBNSearchProductViewController.m
//  MuaBanNhanh
//
//  Created by iSlan on 5/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNSearchProductViewController.h"
#import "MBNSearchProductViewModel.h"

@interface MBNSearchProductViewController ()

@property (weak, nonatomic) IBOutlet UIButton *categoryPickerButton;
@property (weak, nonatomic) IBOutlet UIButton *provincePickerButton;

@property (strong, nonatomic) MBNSearchProductViewModel *viewModel;

@end

@implementation MBNSearchProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupButtonSignal];
}

- (void)setupButtonSignal {
    self.categoryPickerButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *sender) {
        return [RACSignal empty];
    }];
    self.provincePickerButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *sender) {
        return [RACSignal empty];
    }];
}

@end
