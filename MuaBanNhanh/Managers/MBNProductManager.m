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
    [manager GET:@"https://api.muabannhanh.com/article/latest-list" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error;
        
        NSArray *arrayCategories = [MTLJSONAdapter modelsOfClass:[MBNProduct class] fromJSONArray:responseObject[@"result"] error:&error];
        
        success(arrayCategories);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        
        
    }];
}

+ (void)deleteProductWithID:(NSNumber *)productID withCompletion:(void(^)(NSString *resultString, NSString *errorString))completeBlock {
    MBNUser *user = [[MBNUserManager sharedProvider] getLoginUser];
    NSString *requestString = [NSString stringWithFormat:@"https://api.muabannhanh.com/user/article-delete?id=%lu&user_id=%lu&token=%@", (long)[productID integerValue], (long)[user.ID integerValue], user.token];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager mbn_manager];
    [manager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject[@"status"] integerValue] == 200) {
            completeBlock(responseObject[@"message"], nil);
            return;
        }
        
        if (completeBlock) {
            completeBlock(nil, responseObject[@"message"]);
            return;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (completeBlock) {
            completeBlock(nil, error.userInfo[@"message"]);
        }
        
    }];
    
}

+ (void)getProductDetailsWithID:(NSNumber *)productID withCompletion:(void (^) (MBNProduct *product, NSError *error))completeBlock {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager mbn_manager];
    NSString *requestString = [NSString stringWithFormat:@"https://api.muabannhanh.com/article/detail?id=%ld", (long)[productID integerValue]];
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

+ (void)getProductWithType:(NSString *)typeString andPage:(NSInteger)page completeBlock:(void (^) (NSArray *arrProduct, NSError *error))completeBlock {
    
    MBNUser *user = [[MBNUserManager sharedProvider] getLoginUser];
    
    NSString *stringRequest = [NSString stringWithFormat:@"https://api.muabannhanh.com/user/article-list?user_id=%ld&token=%@&page=%ld&limit=10&status=%@",(long)[user.ID integerValue], user.token, (long)page, typeString];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:stringRequest parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error;
        
        if ([responseObject[@"status"] integerValue] == 400) {
            [[MBNActionsManagers sharedInstance] checkRequestErrorAndForceLogout:responseObject];
            NSError *error = [[NSError alloc] initWithDomain:@"Token error" code:400 userInfo:nil];
            completeBlock(@[], error);
            return;
        }
        
        NSArray *arrProducts = [MTLJSONAdapter modelsOfClass:[MBNProduct class] fromJSONArray:responseObject[@"result"] error:&error];
        if (completeBlock) {
            completeBlock(arrProducts, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}

+ (void)createProduct:(NSDictionary *)productInfo completionBlock:(void (^)(MBNProduct *product, NSError *error))completionBlock {
}

+ (void)searchProductWithKeyWord:(NSString *)keyWord page:(NSUInteger)page categoryID:(NSNumber *)categoryID provinceID:(NSNumber *)provinceID completeBlock:(void (^) (NSArray *arrProduct, NSError *error))completeBlock
{
    
    NSString *stringRequest = @"https://api.muabannhanh.com/article/list";
    NSMutableDictionary *params = [@{ @"page" : @(page)} mutableCopy];
    
    // category -1 is all categories
    if ( categoryID && [categoryID integerValue] > -1) {
        [params addEntriesFromDictionary:@{@"category_id": categoryID}];
    }
    
    if (keyWord) {
        [params addEntriesFromDictionary:@{@"q": keyWord}];
    }
    
    // province -1 is all provinces
    if ( provinceID && [provinceID integerValue] > -1) {
        [params addEntriesFromDictionary:@{@"province_id": provinceID}];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:stringRequest parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        
        if ([responseObject[@"status"] integerValue] == 400) {
            [[MBNActionsManagers sharedInstance] checkRequestErrorAndForceLogout:responseObject];
            NSError *error = [[NSError alloc] initWithDomain:@"Token error" code:400 userInfo:nil];
            completeBlock(@[], error);
            return;
        }
        
        NSArray *arrProducts = [MTLJSONAdapter modelsOfClass:[MBNProduct class] fromJSONArray:responseObject[@"result"] error:&error];
        if (completeBlock) {
            completeBlock(arrProducts, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
