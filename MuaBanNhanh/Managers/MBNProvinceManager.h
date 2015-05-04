//
//  MBNProvinceManager.h
//  MuaBanNhanh
//
//  Created by iSlan on 4/28/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBNProvinceManager : NSObject

@property (copy, nonatomic) NSArray *provinces;

+ (instancetype)sharedManager;
+ (void)getProvinces;

@end
