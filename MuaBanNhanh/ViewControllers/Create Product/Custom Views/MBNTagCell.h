//
//  MBNTagCell.h
//  MuaBanNhanh
//
//  Created by iSlan on 4/30/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBNTagButton.h"

@interface MBNTagCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet MBNTagButton *tagButton;

- (void)configWithString:(NSString *)string;
+ (CGSize)getCellSizeWithString:(NSString *)string;

@end
