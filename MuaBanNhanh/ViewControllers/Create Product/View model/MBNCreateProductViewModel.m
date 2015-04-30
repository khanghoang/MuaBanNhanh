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

- (NSMutableArray *)selectedCategories
{
    if (!_selectedCategories) {
        _selectedCategories = [NSMutableArray array];
    }
    return _selectedCategories;
}

- (NSArray *)productTransactionTypeTitles
{
    if (!_productTransactionTypeTitles) {
        _productTransactionTypeTitles = @[@"Cần bán/ Dịch vụ", @"Cần mua/ Cần tìm"];
    }
    return _productTransactionTypeTitles;
}

- (NSArray *)productQualityTitles {
    if (!_productQualityTitles) {
        _productQualityTitles = @[@"Hàng mới 100%", @"Hàng cũ"];
    }
    return _productQualityTitles;
}

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
