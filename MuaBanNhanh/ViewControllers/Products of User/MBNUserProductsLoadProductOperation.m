//
//  MBNUserProductsLoadProductOperation.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/29/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNUserProductsLoadProductOperation.h"

@interface MBNUserProductsLoadProductOperation()

@property (assign, nonatomic) NSUInteger page;
@property (strong, nonatomic) NSNumber *userID;

@property (strong, nonatomic) NSArray *dataPage;

@end

@implementation MBNUserProductsLoadProductOperation

- (instancetype)initWithUserID:(NSNumber *)userID andPage:(NSUInteger)page {
    self = [super init];
    if (self) {
        _userID = userID;
        _page = page;
    }
    
    return self;
}

- (void)loadData:(void (^)(NSArray *, NSError *))finishBlock {
    __weak typeof(self) weakSelf = self;
    
    [MBNProductManager getProductWithUserID:self.userID andPage:self.page completeBlock:^(NSArray *arrProduct, NSError *error) {
        weakSelf.dataPage = arrProduct;
        if (finishBlock) {
            finishBlock(arrProduct, error);
        }
    }];
}

@end
