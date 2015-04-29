//
//  MBNUserProductsContentLoadingViewModel.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/29/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNUserProductsContentLoadingViewModel.h"

@interface MBNUserProductsContentLoadingViewModel()

@property (strong, nonatomic) NSNumber *userID;

@end

@implementation MBNUserProductsContentLoadingViewModel

@synthesize delegate;

- (instancetype)initWithUserID:(NSNumber *)userID {
    self = [super init];
    if (self) {
        _userID = userID;
    }
    
    return self;
}

- (void)loadContent:(void (^)(NSInteger totalItems, NSError *error, AFHTTPRequestOperation *operation))completeBlock {
    
    NSString *requestURL = [NSString stringWithFormat:@"http://api.muabannhanh.com/article/list?user_id=%@&page=1&limit=10", self.userID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
