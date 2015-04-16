//
//  MBNUserManager.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/14/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBNUserManager : NSObject

+ (instancetype)sharedProvider;

- (void)registerWithUsername:(NSString *)username password:(NSString *)password phone:(NSString *)phone email:(NSString *)email success:(void (^) (NSDictionary *result))successBlock andFailure:(void (^) (NSString *stringError))failureBlock;

- (void)loginWithPhone:(NSString *)phone andPassword:(NSString *)password successBlock:(void (^) (NSDictionary *result))successBlock andFailure:(void (^) (NSError *error))failureBlock;

- (void)saveLoginUser:(NSDictionary *)userData;
- (NSDictionary *)getLoginUser;

@end
