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

- (NSDictionary *)productTransactionTypeDictionary
{
    if (!_productTransactionTypeDictionary) {
        _productTransactionTypeDictionary = @{@"Cần bán/ Dịch vụ" : @0,
                                              @"Cần mua/ Cần tìm" : @1};
    }
    return _productTransactionTypeDictionary;
}

- (NSDictionary *)productQualityDictionary {
    if (!_productQualityDictionary) {
        _productQualityDictionary = @{@"Hàng mới 100%" : @1,
                                      @"Mới 100%" : @1,
                                      @"Hàng cũ" : @0};
    }
    return _productQualityDictionary;
}

- (instancetype)init
{
    if (self = [super init]) {
        RAC(self, provinces) = RACObserve([MBNProvinceManager sharedManager], provinces);
    }
    return self;
}

@end
