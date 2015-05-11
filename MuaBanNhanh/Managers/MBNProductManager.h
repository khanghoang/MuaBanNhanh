//
//  MBNProductManager.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBNProductManager : NSObject

+ (void)getLatestProducts:(void (^) (NSArray *arrProducts))success failure:(void (^)(NSError *error))failure;

+ (void)getProductDetailsWithID:(NSNumber *)productID withCompletion:(void (^) (MBNProduct *product, NSError *error))completeBlock;

+ (void)getProductWithCategoryID:(NSNumber *)catID andPage:(NSInteger)page completeBlock:(void (^) (NSArray *arrProduct, NSError *error))completeBlock;

+ (void)getProductWithUserID:(NSNumber *)userID andPage:(NSInteger)page completeBlock:(void (^) (NSArray *arrProduct, NSError *error))completeBlock;

+ (void)getProductWithType:(NSString *)typeString andPage:(NSInteger)page completeBlock:(void (^) (NSArray *arrProduct, NSError *error))completeBlock;

+ (void)deleteProductWithID:(NSNumber *)productID withCompletion:(void(^)(NSString *resultString, NSString *errorString))completeBlock;

+ (void)searchProductWithKeyWord:(NSString *)keyWord page:(NSUInteger)page categoryID:(NSNumber *)categoryID provinceID:(NSNumber *)provinceID completeBlock:(void (^) (NSArray *arrProduct, NSError *error))completeBlock;

@end
