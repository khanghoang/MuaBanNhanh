//
//  MBNManageProductLoadOperation.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/29/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBNManageProductLoadOperation : NSBlockOperation
<
KHLoadingOperationProtocol
>

- (instancetype)initWithType:(NSString *)type andPage:(NSUInteger)page;
- (void)loadData:(void (^)(NSArray *data, NSError *error))finishBlock;

@end
