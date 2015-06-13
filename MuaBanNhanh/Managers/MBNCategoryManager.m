//
//  MBNCategoryManager.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/1/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNCategoryManager.h"

@implementation MBNCategoryManager

+ (instancetype)sharedProvider
{
    static MBNCategoryManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MBNCategoryManager alloc] init];
    });

    return instance;
}

- (void)getCategories:(void (^) (NSArray *arrCategories))success failure:(void (^)(NSError *error))failure {
    if (self.categories && self.categories.count) {
        if (success) {
            success(self.categories);
        }
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://api.muabannhanh.com/category/list" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error;
        
        NSArray *arrayCategories = [MTLJSONAdapter modelsOfClass:[MBNCategory class] fromJSONArray:responseObject[@"result"] error:&error];
        self.categories = arrayCategories;
        if (success) {
            success(arrayCategories);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (NSArray *)getSearchableCategories {
    NSMutableArray *searchableCategories = [self.categories mutableCopy];
    
    MBNCategory *cat = [MBNCategory new];
    cat.name = @"Chuyên mục";
    cat.ID = @(-1);
    
    
    [searchableCategories insertObject:cat atIndex:-1];
    return searchableCategories;
}

@end
