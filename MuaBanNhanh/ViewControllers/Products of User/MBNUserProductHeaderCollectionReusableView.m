//
//  MBNUserProductHeaderCollectionReusableView.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/29/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNUserProductHeaderCollectionReusableView.h"

@interface MBNUserProductHeaderCollectionReusableView()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewCover;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;

@end

@implementation MBNUserProductHeaderCollectionReusableView

- (void)configWithUser:(MBNUser *)user {
    [self.imgViewAvatar setImageWithURL:user.avatarImageUrl placeholderImage:[UIImage imageNamed:@"df_avatar"]];
    [self.imgViewCover setImageWithURL:user.coverImageUrl placeholderImage:[UIImage imageNamed:@"df_cover"]];
    self.lblAddress.text = [user getDisplayAddressString];
    self.lblUsername.text = user.name;
}

@end
