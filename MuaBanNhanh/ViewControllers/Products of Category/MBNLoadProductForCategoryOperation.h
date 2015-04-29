//
//  MBNLoadProductForCategoryOperation.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/9/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBNLoadProductForCategoryOperation : NSBlockOperation
<
KHLoadingOperationProtocol
>

- (instancetype)initWithCategoryID:(NSNumber *)categoryID andPage:(NSUInteger)page;

- (void)loadData:(void (^)(NSArray *data, NSError *error))finishBlock;

@end
