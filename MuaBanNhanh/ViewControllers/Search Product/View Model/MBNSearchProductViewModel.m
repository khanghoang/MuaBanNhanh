//
//  MBNSearchProductViewModel.m
//  MuaBanNhanh
//
//  Created by iSlan on 5/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNSearchProductViewModel.h"
#import "MBNProvinceManager.h"

@interface MBNSearchProductViewModel()

@property (strong, readwrite) NSMutableArray *products;

@end

@implementation MBNSearchProductViewModel

- (instancetype)init
{
    if (self = [super init]) {
        RAC(self, provinces) = RACObserve([MBNProvinceManager sharedManager], searchableProvinces);
        RAC(self, categories) = RACObserve([MBNCategoryManager sharedProvider], getSearchableCategories);
        _products = [NSMutableArray array];
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
            NSMutableArray *array = (NSMutableArray *)[self mutableSetValueForKey:@"products"];
            [array addObjectsFromArray:arrProduct];
        }
    }];
}

- (void)searchProductsWithKeyWord:(NSString *)keyWord page:(NSNumber *)page
{
    @weakify(self);
    self.page = [page integerValue];
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
            NSMutableArray *array = (NSMutableArray *)[self mutableSetValueForKey:@"products"];
            [array addObjectsFromArray:arrProduct];
        }
    }];
}

@end
