//
//  MBNLoadProductForCategoryOperation.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/9/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNLoadProductForCategoryOperation.h"

@interface MBNLoadProductForCategoryOperation()

@property (assign, nonatomic) NSUInteger page;
@property (assign, nonatomic) NSUInteger userID;

@property (strong, nonatomic) NSArray *dataPage;
@property (strong, nonatomic) NSNumber *categoryID;

@end

@implementation MBNLoadProductForCategoryOperation

- (instancetype)initWithCategoryID:(NSNumber *)categoryID andPage:(NSUInteger)page {
    self = [super init];
    if (self) {
        _categoryID = categoryID;
        _page = page;
    }
    
    return self;
}

- (void)loadData:(void (^)(NSArray *, NSError *))finishBlock {
    __weak typeof(self) weakSelf = self;
    
    [MBNProductManager getProductWithCategoryID:self.categoryID andPage:self.page completeBlock:^(NSArray *arrProduct, NSError *error) {
        weakSelf.dataPage = arrProduct;
        if (finishBlock) {
            finishBlock(arrProduct, error);
        }
    }];
}

@end
