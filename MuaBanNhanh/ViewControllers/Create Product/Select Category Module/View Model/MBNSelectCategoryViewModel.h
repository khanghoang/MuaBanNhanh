//
//  MBNSelectCategoryViewModel.h
//  MuaBanNhanh
//
//  Created by iSlan on 4/29/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBNSelectCategoryViewModel : NSObject

@property (copy, nonatomic) NSArray *categories;
@property (copy, nonatomic) NSMutableArray *selectedCategories;
@property (copy, nonatomic) NSString *pullCategoriesErrorMessage;

- (void)pullCategories;

@end
