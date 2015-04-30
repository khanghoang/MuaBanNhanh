//
//  MBNManageProductViewModel.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/29/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBNManageProductViewModel : NSObject

@property (readonly, nonatomic) NSDictionary *types;
@property (readonly, nonatomic) NSDictionary *viewControllers;
@property (readonly, nonatomic) NSArray *order;

@property (strong, nonatomic) NSNumber *currentIndex;

- (NSInteger)indexOfViewController:(UIViewController *)controller;
- (NSInteger)indexOfViewTitle:(NSString *)aTitle;

@end
