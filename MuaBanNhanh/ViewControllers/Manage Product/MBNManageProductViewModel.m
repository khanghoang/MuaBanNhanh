//
//  MBNManageProductViewModel.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/29/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNManageProductViewModel.h"

@interface MBNManageProductViewModel()

@property (strong, nonatomic) NSDictionary *types;

@end

@implementation MBNManageProductViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _types = @{
                   @"Tất cả": @"All",
                   @"Cần bán": @"is_saled",
                   @"Đã kích hoạt": @"ACTIVED",
                   @"Chưa kích hoạt": @"INACTIVED",
                   @"Cần chỉnh sửa": @"REJECTED"
                   };
    }
    
    return self;
}

@end
