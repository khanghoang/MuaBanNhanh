//
//  MBNUserProductsContentLoadingViewModel.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/29/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBNUserProductsContentLoadingViewModel : NSObject
<
KHContentLoadingProtocol,
KHTableViewSectionModel
>

- (instancetype)initWithUserID:(NSNumber *)userID;

@end