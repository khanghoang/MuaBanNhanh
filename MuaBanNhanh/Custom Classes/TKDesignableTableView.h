//
//  TKDesignableTableView.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 5/6/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface TKDesignableTableView : UITableView

@property (nonatomic) IBInspectable NSInteger borderRadius;
@property (nonatomic) IBInspectable NSInteger borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;

@property (nonatomic) IBInspectable UIColor *shadowColor;
@property (nonatomic) IBInspectable CGSize shadowOffset;
@property (nonatomic) IBInspectable CGFloat shadowRadius;

@end