//
//  MBNSelectCategoryViewModel.m
//  MuaBanNhanh
//
//  Created by iSlan on 4/29/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNSelectCategoryViewModel.h"

@implementation MBNSelectCategoryViewModel

- (NSMutableArray *)selectedCategories
{
    if (!_selectedCategories) {
        _selectedCategories = [NSMutableArray array];
    }
    return _selectedCategories;
}

- (void)pullCategories {
    [[MBNCategoryManager sharedProvider] getCategories:^(NSArray *arrCategories) {
        self.categories = arrCategories;
    } failure:^(NSError *error) {
        self.pullCategoriesErrorMessage = error.description;
    }];
}

@end
