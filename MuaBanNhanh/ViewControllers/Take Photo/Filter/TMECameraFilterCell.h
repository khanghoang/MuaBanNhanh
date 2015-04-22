//
//  TMECameraFilterCell.h
//  ThreeMin
//
//  Created by Khoa Pham on 11/19/14.
//  Copyright (c) 2014 3min. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMECameraFilterCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *filterImageButton;
@property (weak, nonatomic) IBOutlet UILabel *filterLabel;
@property (weak, nonatomic) IBOutlet UIImageView *activeOverlayImageView;

@end
