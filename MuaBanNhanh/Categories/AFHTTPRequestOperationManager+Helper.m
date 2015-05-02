//
//  AFHTTPRequestOperationManager+Helper.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/28/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "AFHTTPRequestOperationManager+Helper.h"

@implementation AFHTTPRequestOperationManager (Helper)

+ (AFHTTPRequestOperationManager *)mbn_manager {
    
    static AFHTTPRequestOperationManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [AFHTTPRequestOperationManager manager];
        instance.requestSerializer = [AFJSONRequestSerializer serializer];
        AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
        instance.responseSerializer = response;
        response.readingOptions = NSJSONReadingAllowFragments;
        [instance.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    });

    return instance;
}

@end
