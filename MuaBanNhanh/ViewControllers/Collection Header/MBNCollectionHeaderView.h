//
//  MBNCollectionHeaderView.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBNCollectionHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIButton *btnViewAll;

- (void)configWithHeaderText:(NSString *)headerText;

@end
