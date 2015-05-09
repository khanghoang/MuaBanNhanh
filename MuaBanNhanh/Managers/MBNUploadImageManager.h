//
//  MBNUploadImageManager.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/23/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MBN_UPLOAD_PRODUCT_IMAGE,
    MBN_UPLOAD_USER_COVER,
    MBN_UPLOAD_USER_AVATAR,
} MBN_UPLOAD_IMAGE;

@interface MBNUploadImageManager : NSObject

+ (instancetype)sharedProvider;

- (void)uploadImage:(UIImage *)image type:(MBN_UPLOAD_IMAGE)type withFinishBlock:(void (^) (id responseObject, NSError *error))finishBlock;

- (AFHTTPRequestOperation *)updateProductWithProductID:(NSNumber *)productID withDictionary:(NSDictionary *)dictionary withCompletionBlock:(void (^)(id reponseObject, NSError *error))completionBlock;
- (AFHTTPRequestOperation *)createProductWithDictionary:(NSDictionary *)dictionary withCompletionBlock:(void (^)(id reponseObject, NSError *error))completionBlock;
- (AFHTTPRequestOperation *)uploadProductImage:(UIImage *)image withCompletionBlock:(void (^)(AFHTTPRequestOperation *operation, id reponseObject, NSError *error))completionBlock;

@end
