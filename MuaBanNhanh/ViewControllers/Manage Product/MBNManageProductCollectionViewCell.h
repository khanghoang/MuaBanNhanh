//
//  MBNManageProductCollectionViewCell.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/30/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBNManageProductCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *menuButton;

- (void)configWithData:(id)data;

@end
