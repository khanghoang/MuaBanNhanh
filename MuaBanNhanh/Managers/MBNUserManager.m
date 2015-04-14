//
//  MBNUserManager.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/14/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNUserManager.h"

@implementation MBNUserManager

+ (instancetype)sharedProvider
{
    static MBNUserManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MBNUserManager alloc] init];
    });

    return instance;
}

- (void)registerWithUsername:(NSString *)username password:(NSString *)password phone:(NSString *)phone email:(NSString *)email success:(void (^) (NSDictionary *result))successBlock andFailure:(void (^) (NSString *stringError))failureBlock {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"phone": phone,
                             @"password": password,
                             @"confirm_password": password,
                             @"name": username,
                             @"email": email
                             };
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:@"https://api.muabannhanh.com/user/register"
       parameters:params
          success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
              
              if ([responseObject[@"status"] integerValue] == 200) {
                  if (successBlock) {
                      successBlock(responseObject[@"result"]);
                      return;
                  }
              }
              
              if (failureBlock) {
                  failureBlock(responseObject[@"message"]);
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (failureBlock) {
                  failureBlock(@"Có lỗi, vui lòng kiểm tra kết nối mạng và thử lại");
              }
          }];
}

@end
