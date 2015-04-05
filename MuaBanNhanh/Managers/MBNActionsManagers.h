//
//  MBNActionsManagers.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBNActionsManagers : NSObject

+ (instancetype)sharedInstance;
- (void)callNumber:(NSString *)numberString;

@end
