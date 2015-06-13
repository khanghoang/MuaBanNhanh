//
//  MBNCategoryManager.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/1/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBNCategoryManager : NSObject

@property (copy, nonatomic) NSArray *categories;

- (NSArray *)getSearchableCategories;
+ (instancetype)sharedProvider;
- (void)getCategories:(void (^) (NSArray *arrCategories))success failure:(void (^)(NSError *error))failure;

@end
