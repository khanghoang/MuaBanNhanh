//
//  MBNProvinceManager.m
//  MuaBanNhanh
//
//  Created by iSlan on 4/28/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNProvinceManager.h"

@implementation MBNProvinceManager

+ (instancetype)sharedManager
{
    static MBNProvinceManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MBNProvinceManager alloc] init];
    });
    
    return instance;
}

+ (void)getProvinces {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://api.muabannhanh.com/province/list" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSArray *provinces = [MTLJSONAdapter modelsOfClass:[MBNProvince class] fromJSONArray:responseObject[@"result"] error:&error];
        
        [MBNProvinceManager sharedManager].provinces = provinces;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (NSArray *)searchableProvinces {
    NSMutableArray *provinces = [self.provinces mutableCopy];
    // all province
    MBNProvince *province = [MBNProvince new];
    province.name = @"Tỉnh thành";
    province.ID = @(-1);
    [provinces insertObject:province atIndex:0];
    return provinces;
}

@end
