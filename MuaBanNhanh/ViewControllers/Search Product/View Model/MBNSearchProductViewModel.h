//
//  MBNSearchProductViewModel.h
//  MuaBanNhanh
//
//  Created by iSlan on 5/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBNSearchProductViewModel : NSObject

@property (copy, nonatomic) NSArray *provinces;
@property (copy, nonatomic) NSArray *categories;
@property (strong, readonly) NSMutableArray *products;
@property (assign, nonatomic) NSUInteger page;
@property (strong, nonatomic) MBNCategory *selectedCategory;
@property (strong, nonatomic) MBNProvince *selectedProvince;

- (void)searchProductsWithKeyWord:(NSString *)keyWord;
- (void)searchProductsWithKeyWord:(NSString *)keyWord page:(NSNumber *)page;

@end
