//
//  MBNContentLoadingViewModel.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/9/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNContentLoadingViewModel.h"

@implementation MBNContentLoadingViewModel

@synthesize delegate;

- (void)loadContent:(void (^)(NSInteger totalItems, NSError *error, AFHTTPRequestOperation *operation))completeBlock {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://api.muabannhanh.com/article/list?category_id=0&page=1&limit=10" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSNumber *totalPages = @((int)responseObject[@"total_pages"]);
        
        if (completeBlock) {
            completeBlock([totalPages integerValue], nil, nil);
        }
        
        [self.delegate didLoadWithResultWithTotalPage:-1 error:nil operation:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate didLoadWithResultWithTotalPage:-1 error:error operation:nil];
    }];
}

- (void)loadContent {
    [self loadContent:nil];
}

- (id)objectAtIndex:(NSUInteger)index {
    return @"";
}

- (NSUInteger)count {
    return 1;
}

- (NSString *)title {
    return @"";
}

@end
