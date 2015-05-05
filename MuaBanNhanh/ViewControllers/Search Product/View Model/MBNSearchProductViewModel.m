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

- (instancetype)init
{
    if (self = [super init]) {
        RAC(self, provinces) = RACObserve([MBNProvinceManager sharedManager], provinces);
        RAC(self, categories) = RACObserve([MBNCategoryManager sharedProvider], categories);
    }
    return self;
}

@end
