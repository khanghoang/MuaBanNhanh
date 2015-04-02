//
//  MBNCategoryManager.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/1/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNCategoryManager.h"

@interface MBNCategoryManager()

@end

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
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://muabannhanh.com/api/category/list" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error;
        
        NSArray *arrayCategories = [MTLJSONAdapter modelsOfClass:[MBNCategory class] fromJSONArray:responseObject[@"result"] error:&error];
        
        success(arrayCategories);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        
        
    }];
}

@end
