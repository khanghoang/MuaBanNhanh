//
//  MBNUserProductsLoadProductOperation.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/29/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNUserProductsLoadProductOperation.h"

@interface MBNUserProductsLoadProductOperation()

@property (nonatomic, readonly) NSIndexSet *indexes;
@property (nonatomic, readonly) NSArray *dataPage;
@property (nonatomic, strong) NSNumber *userID;

@end

@implementation MBNUserProductsLoadProductOperation

- (instancetype)initWithIndexes:(NSIndexSet *)indexes andUserId:(NSNumber *)userID {
    self = [super init];
    
    if (self) {
        _indexes = indexes;
        _userID = userID;
    }
    
    return self;
}

- (void)loadData:(void (^)(NSArray *data, NSError *error))finishBlock {
    typeof(self) weakSelf = self;
    NSMutableArray *dataPage = [NSMutableArray arrayWithCapacity:10];
    
    NSString *stringRequest = [NSString stringWithFormat:@"http://api.muabannhanh.com/article/list?user_id=%@&page=%lu&limit=10",self.userID, self.indexes.lastIndex/10];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:stringRequest parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error;
        
        NSArray *arrayCategories = [MTLJSONAdapter modelsOfClass:[MBNProduct class] fromJSONArray:responseObject[@"result"] error:&error];
        
        [weakSelf.indexes enumerateIndexesUsingBlock: ^(NSUInteger idx, BOOL *stop) {
            id data = [arrayCategories objectAtIndex:idx % 10];
            dataPage[idx % 10] = data;
        }];
        
        weakSelf->_dataPage = dataPage;
        if (finishBlock) {
            finishBlock(dataPage, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

@end
