//
//  MBNProvinceManager.m
//  MuaBanNhanh
//
//  Created by iSlan on 4/28/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNProvinceManager.h"

@implementation MBNProvinceManager

- (RACSignal *)getProvinces {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:@"https://api.muabannhanh.com/province/list" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSError *error;
            NSArray *provinces = [MTLJSONAdapter modelsOfClass:[MBNProvince class] fromJSONArray:responseObject[@"result"] error:&error];
            [subscriber sendNext:provinces];
            [subscriber sendCompleted];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

@end
