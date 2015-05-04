//
//  MBNSearchProductViewModel.m
//  MuaBanNhanh
//
//  Created by iSlan on 5/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNSearchProductViewModel.h"
#import "MBNProvinceManager.h"

@implementation MBNSearchProductViewModel

- (NSDictionary *)productQuality
{
    if (!_productQuality) {
        _productQuality = @{@"Hàng cũ" : @0,
                            @"Hảng mới 100%" : @1};
    }
    return _productQuality;
}

- (instancetype)init
{
    if (self = [super init]) {
        RAC(self, provinces) = RACObserve([MBNProvinceManager sharedManager], provinces);
    }
    return self;
}

@end
