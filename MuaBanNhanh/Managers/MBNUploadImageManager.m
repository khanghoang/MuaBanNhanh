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
        
        if (finishBlock) {
            finishBlock(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (finishBlock) {
            finishBlock(nil, error);
        }
        
    }];
    
}


@end
