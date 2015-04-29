//
//  MBNManageProductLoadOperation.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/29/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNManageProductLoadOperation.h"

@interface MBNManageProductLoadOperation()

@property (assign, nonatomic) NSUInteger page;
@property (strong, nonatomic) NSString *typeString;
@property (strong, nonatomic) NSArray *dataPage;

@end

@implementation MBNManageProductLoadOperation

- (instancetype)initWithType:(NSString *)type andPage:(NSUInteger)page {
    self = [super init];
    if (self) {
        _page = page;
        _typeString = type;
    }
    
    return self;
}

- (void)loadData:(void (^)(NSArray *, NSError *))finishBlock {
    __weak typeof(self) weakSelf = self;
    [MBNProductManager getProductWithType:self.typeString andPage:self.page completeBlock:^(NSArray *arrProduct, NSError *error) {
        
        weakSelf.dataPage = arrProduct;
        if (finishBlock) {
            finishBlock(arrProduct, error);
        }
    
    }];
}

@end
