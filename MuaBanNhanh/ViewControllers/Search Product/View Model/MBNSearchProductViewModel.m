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
        RAC(self, provinces) = RACObserve([MBNProvinceManager sharedManager], searchableProvinces);
        RAC(self, categories) = RACObserve([MBNCategoryManager sharedProvider], categories);
    }
    return self;
}

- (void)searchProductsWithKeyWord:(NSString *)keyWord
{
    @weakify(self);
    [SVProgressHUD show];
    [MBNProductManager searchProductWithKeyWord:keyWord
                                           page:self.page
                                     categoryID:self.selectedCategory.ID
                                     provinceID:self.selectedProvince.ID
                                  completeBlock:^(NSArray *arrProduct, NSError *error)
    {
        [SVProgressHUD dismiss];
        @strongify(self);
        if (error) {
            
        } else {
            self.products = arrProduct;
        }
    }];
}

@end
