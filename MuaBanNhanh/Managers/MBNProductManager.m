//
//  MBNProductManager.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNProductManager.h"

@implementation MBNProductManager

+ (instancetype)sharedProvider
{
    static MBNProductManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MBNProductManager alloc] init];
    });

    return instance;
}

+ (void)getLatestProducts:(void (^) (NSArray *arrProducts))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://api.muabannhanh.com/article/latest-list" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error;
        
        NSArray *arrayCategories = [MTLJSONAdapter modelsOfClass:[MBNProduct class] fromJSONArray:responseObject[@"result"] error:&error];
        
        success(arrayCategories);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        
        
    }];
}

+ (void)getProductDetailsWithID:(NSNumber *)productID withCompletion:(void (^) (MBNProduct *product, NSError *error))completeBlock {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager mbn_manager];
    NSString *requestString = [NSString stringWithFormat:@"http://api.muabannhanh.com/article/detail?id=%ld", (long)[productID integerValue]];
    [manager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error;
        
        MBNProduct *product = [MTLJSONAdapter modelOfClass:[MBNProduct class] fromJSONDictionary:[responseObject[@"result"] firstObject] error:&error];
        
        if (completeBlock) {
            completeBlock(product, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (completeBlock) {
            completeBlock(nil, error);
        }
        
    }];
}

+ (void)getProductWithCategoryID:(NSNumber *)catID andPage:(NSInteger)page completeBlock:(void (^) (NSArray *arrProduct, NSError *error))completeBlock {
    
    NSString *stringRequest = [NSString stringWithFormat:@"https://api.muabannhanh.com/article/list?category_id=%ld&page=%lu&limit=10",(long)[catID integerValue], page];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:stringRequest parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error;
        
        NSArray *arrProducts = [MTLJSONAdapter modelsOfClass:[MBNProduct class] fromJSONArray:responseObject[@"result"] error:&error];
        if (completeBlock) {
            completeBlock(arrProducts, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}

+ (void)getProductWithUserID:(NSNumber *)userID andPage:(NSInteger)page completeBlock:(void (^) (NSArray *arrProduct, NSError *error))completeBlock {
    
    NSString *stringRequest = [NSString stringWithFormat:@"https://api.muabannhanh.com/article/list?user_id=%ld&page=%lu&limit=10",(long)[userID integerValue], page];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:stringRequest parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error;
        
        NSArray *arrProducts = [MTLJSONAdapter modelsOfClass:[MBNProduct class] fromJSONArray:responseObject[@"result"] error:&error];
        if (completeBlock) {
            completeBlock(arrProducts, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}

@end
