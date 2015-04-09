//
//  TKDesignableView.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/9/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface TKDesignableView : UIView

@property (nonatomic) IBInspectable NSInteger borderRadius;
@property (nonatomic) IBInspectable NSInteger borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;

@end
