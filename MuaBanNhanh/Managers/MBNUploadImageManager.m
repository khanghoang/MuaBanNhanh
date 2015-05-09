//
//  MBNUploadImageManager.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/23/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNUploadImageManager.h"

@implementation MBNUploadImageManager

+ (instancetype)sharedProvider
{
    static MBNUploadImageManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MBNUploadImageManager alloc] init];
    });

    return instance;
}

- (NSString *)buildRequestStringWithType:(MBN_UPLOAD_IMAGE)type {
    NSString *stringType = @"upload-cover";
    
    switch (type) {
        case MBN_UPLOAD_USER_COVER:
            stringType = @"upload-cover";
            break;
            
        case MBN_UPLOAD_USER_AVATAR:
            stringType = @"upload-avatar";
            break;
            
        default:
            break;
    }
    
    MBNUser *currentLoginUser = [[MBNUserManager sharedProvider] getLoginUser];
    NSString *finalString = [NSString stringWithFormat:@"https://api.muabannhanh.com/user/%@?id=%ld&token=%@", stringType, (long)[currentLoginUser.ID integerValue], currentLoginUser.token];
    
    return finalString;
    
}

- (void)uploadImage:(UIImage *)image type:(MBN_UPLOAD_IMAGE)type withFinishBlock:(void (^) (id responseObject, NSError *error))finishBlock {
    
    NSDictionary *params = @{
        @"content": [UIImageJPEGRepresentation(image, 0.8) base64EncodedString],
        @"extension": @"jpeg"
    };
    
    NSString *requestString = [self buildRequestStringWithType:type];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:requestString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"status"] integerValue] == 400) {
            [[MBNActionsManagers sharedInstance] checkRequestErrorAndForceLogout:responseObject];
            NSError *error = [[NSError alloc] initWithDomain:@"Token error" code:400 userInfo:nil];
            finishBlock(@[], error);
            return;
        }
        
        if (finishBlock) {
            finishBlock(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (finishBlock) {
            finishBlock(nil, error);
        }
        
    }];
    
}

- (AFHTTPRequestOperation *)createProductWithDictionary:(NSDictionary *)dictionary withCompletionBlock:(void (^)(id reponseObject, NSError *error))completionBlock  {
    // TODO: repeated code
    MBNUser *currentLoginUser = [[MBNUserManager sharedProvider] getLoginUser];
    NSString *requestString = [NSString stringWithFormat:@"https://api.muabannhanh.com/user/article-add?user_id=%ld&token=%@", (long)[currentLoginUser.ID integerValue], currentLoginUser.token];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:requestString parameters:dictionary error:&error];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 400) {
            [[MBNActionsManagers sharedInstance] checkRequestErrorAndForceLogout:responseObject];
            return;
        }
        
        if (completionBlock) {
            completionBlock(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completionBlock) {
            completionBlock(nil, error);
        }
        
    }];
    
    return operation;
}

- (AFHTTPRequestOperation *)updateProductWithProductID:(NSNumber *)productID withDictionary:(NSDictionary *)dictionary withCompletionBlock:(void (^)(id reponseObject, NSError *error))completionBlock  {
    // TODO: repeated code
    MBNUser *currentLoginUser = [[MBNUserManager sharedProvider] getLoginUser];
    NSString *requestString = [NSString stringWithFormat:@"https://api.muabannhanh.com/user/article-edit?user_id=%ld&token=%@&id=%ld", (long)[currentLoginUser.ID integerValue], currentLoginUser.token, (long)[productID integerValue]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:requestString parameters:dictionary error:&error];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (completionBlock) {
            completionBlock(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completionBlock) {
            completionBlock(nil, error);
        }
    }];
    
    return operation;
}

- (AFHTTPRequestOperation *)uploadProductImage:(UIImage *)image withCompletionBlock:(void (^)(AFHTTPRequestOperation *operation, id reponseObject, NSError *error))completionBlock {
    
    NSDictionary *params = @{
                             @"content": [UIImageJPEGRepresentation(image, 0.8) base64EncodedString],
                             @"extension": @"jpeg"
                             };
    
    MBNUser *currentLoginUser = [[MBNUserManager sharedProvider] getLoginUser];
    NSString *requestString = [NSString stringWithFormat:@"https://api.muabannhanh.com/user/upload-image?id=%ld&token=%@", (long)[currentLoginUser.ID integerValue], currentLoginUser.token];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:requestString parameters:params error:&error];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (completionBlock) {
            completionBlock(operation, responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completionBlock) {
            completionBlock(operation, nil, error);
        }
    }];
    
    return operation;
}

@end
