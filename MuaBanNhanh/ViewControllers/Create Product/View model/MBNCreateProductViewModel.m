//
//  MBNCreateProductViewModel.m
//  MuaBanNhanh
//
//  Created by iSlan on 4/28/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNCreateProductViewModel.h"
#import "MBNProvinceManager.h"

@implementation MBNCreateProductViewModel

- (void)getProvinces {
    @weakify(self);
    MBNProvinceManager *manager = [[MBNProvinceManager alloc] init];
    [[manager getProvinces] subscribeNext:^(NSArray *provinces) {
        @strongify(self);
        self.provinces = provinces;
    } error:^(NSError *error) {
        @strongify(self);
        self.getProvincesErrorMessage = error.description;
    }];
}

@end
