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

- (void)logout {
    [self saveLoginUser:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_LOGOUT
                                                        object:nil];
}

- (void)saveLoginUser:(MBNUser *)user {
    NSData *encodedUser = [NSKeyedArchiver archivedDataWithRootObject:user];
    [[NSUserDefaults standardUserDefaults] setObject:encodedUser forKey:NS_USER_DEFAULT_LOGIN_USER];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (MBNUser *)getLoginUser {
    NSData *encodedUser = [[NSUserDefaults standardUserDefaults] objectForKey:NS_USER_DEFAULT_LOGIN_USER];
    MBNUser *user = [NSKeyedUnarchiver unarchiveObjectWithData:encodedUser];
    return user;
}

- (NSString *)token {
    MBNUser *currentUser = [self getLoginUser];
    return currentUser.token;
}

- (void)loginWithPhone:(NSString *)phone andPassword:(NSString *)password successBlock:(void (^) (MBNUser *user))successBlock andFailure:(void (^) (NSString *errorString))failureBlock {
    
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
          success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
              
              if ([responseObject[@"status"] integerValue] == 400) {
                  if (failureBlock) {
                      failureBlock(responseObject[@"message"]);
                  }
                  
                  return;
              }
              
              if ([responseObject[@"status"] integerValue] == 200) {
                  
                  // write login user data into NSUserDefault
                  MBNUser *user = [MTLJSONAdapter modelOfClass:[MBNUser class] fromJSONDictionary:responseObject[@"result"] error:nil];
                  
                  [self saveLoginUser:user];
                  
                  // broadcast the login user
                  [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_LOGIN object:user];
                  
                  // close the login popup
                  if (successBlock) {
                      successBlock(user);
                  }
                  
                  return;
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [SVProgressHUD showErrorWithStatus:@"Có lỗi phát sinh, vui lòng thử lại."];
              if (failureBlock) {
                  failureBlock(@"Vui lòng kiểm tra kết nối mạng và thử lại");
              }
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

- (void)getOwnInformation:(void (^) (MBNUser* user))successBlock failure:(void (^) (NSString *errorString))failureBlock {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    MBNUser *currentUser = [self getLoginUser];
    NSString *requestUrl = [NSString stringWithFormat:@"http://api.muabannhanh.com/user/profile?id=%@&token=%@", currentUser.ID, currentUser.token];
    
    [manager GET:requestUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"status"] integerValue] == 400) {
            if (failureBlock) {
                failureBlock(responseObject[@"message"]);
            }
            
            return;
        }
        
        if ([responseObject[@"status"] integerValue] == 200) {
            
            // write login user data into NSUserDefault
            MBNUser *user = [MTLJSONAdapter modelOfClass:[MBNUser class] fromJSONDictionary:responseObject[@"result"] error:nil];
            
            // close the login popup
            if (successBlock) {
                successBlock(user);
            }
            
            return;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Có lỗi phát sinh, vui lòng thử lại."];
        if (failureBlock) {
            failureBlock(@"Vui lòng kiểm tra kết nối mạng và thử lại");
        }
        
        
        
    }];
    
}

@end
