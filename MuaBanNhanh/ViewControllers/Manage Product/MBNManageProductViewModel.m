//
//  MBNManageProductViewModel.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/29/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNManageProductViewModel.h"
#import "MBNMangeProductListViewController.h"

@interface MBNManageProductViewModel()

@property (strong, nonatomic) NSDictionary *types;
@property (strong, nonatomic) NSDictionary *viewControllers;
@property (strong, nonatomic) NSArray *order;

@end

@implementation MBNManageProductViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _order = @[
                   @"All",
                   @"is_saled",
                   @"ACTIVED",
                   @"INACTIVED",
                   @"REJECTED"
                   ],
        _types = @{
                   @"All": @"Tất cả",
                   @"is_saled": @"is_saled",
                   @"ACTIVED": @"Đã kích hoạt",
                   @"INACTIVED": @"Chưa kích hoạt",
                   @"REJECTED": @"Cần chỉnh sửa"
                   };
        
        _viewControllers = @{
                             @"All": [self listViewControllerWithType:@"All"],
                             @"is_saled": [self listViewControllerWithType:@"is_saled"],
                             @"ACTIVED": [self listViewControllerWithType:@"ACTIVED"],
                             @"INACTIVED": [self listViewControllerWithType:@"INACTIVED"],
                             @"REJECTED": [self listViewControllerWithType:@"REJECTED"]
                             };
        _currentIndex = @(0);
    }
    
    return self;
}

- (MBNMangeProductListViewController *)listViewControllerWithType:(NSString *)type {
    MBNMangeProductListViewController *vc = [MBNMangeProductListViewController tme_instantiateFromStoryboardNamed:@"ManageProduct"];
    vc.typeString = type;
    return vc;
}

- (NSInteger)indexOfViewController:(MBNMangeProductListViewController *)controller {
    __block NSInteger index = -1;
    [self.order enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
        if (title == controller.typeString) {
            index = idx;
        }
    }];
    
    return index;
}

- (NSInteger)indexOfViewTitle:(NSString *)aTitle {
    __block NSInteger index = -1;
    [[self.types allValues] enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
        if ([aTitle isEqualToString:title]) {
            index = idx;
        }
    }];
    
    return index;
}

@end
