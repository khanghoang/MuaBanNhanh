//
//  MBNUserManager.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/14/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNUserManager.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

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

- (void)loginWithPhone:(NSString *)phone andPassword:(NSString *)password successBlock:(void (^) (NSDictionary *result))successBlock andFailure:(void (^) (NSError *error))failureBlock {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *params = @{
                             @"phone": phone,
                             @"password": password,
                             @"user_agent": @"MBN iOS",
                             @"ip": [self getIPAddress]
                             };
    
    [manager POST:@"https://api.muabannhanh.com/user/login"
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
          }];
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

- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

@end
