//
//  MBNContentLoadingViewModel.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/9/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNContentLoadingViewModel.h"

@interface MBNContentLoadingViewModel()

@property (strong, nonatomic) NSNumber *categoryID;

@end

@implementation MBNContentLoadingViewModel

@synthesize delegate;

- (instancetype)initWithCategoryID:(NSNumber *)categoryID {
    self = [super init];
    if (self) {
        _categoryID = categoryID;
    }
    
    return self;
}

- (void)loadContent:(void (^)(NSInteger totalItems, NSError *error, AFHTTPRequestOperation *operation))completeBlock {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *requestURL = [NSString stringWithFormat:@"https://api.muabannhanh.com/article/list?category_id=%@&page=1&limit=10", self.categoryID];
    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSInteger totalPages = [responseObject[@"total_pages"] integerValue];
        
        if (completeBlock) {
            completeBlock(totalPages, nil, nil);
        }
        
        [self.delegate didLoadWithResultWithTotalPage:totalPages error:nil operation:nil];
        
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
