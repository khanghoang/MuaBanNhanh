//
//  TKDesignableButton.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/23/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface TKDesignableButton : UIButton

@property (nonatomic) IBInspectable NSInteger borderRadius;
@property (nonatomic) IBInspectable NSInteger borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;

@end
