//
//  MBNCollectionHeaderView.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNCollectionHeaderView.h"

@interface MBNCollectionHeaderView()

@property (weak, nonatomic) IBOutlet UILabel *lblHeaderName;

@end

@implementation MBNCollectionHeaderView

- (void)awakeFromNib {
    // Initialization code
    self.btnViewAll.layer.cornerRadius = 2.0f;
    [self.btnViewAll.layer masksToBounds];
}

- (void)configWithHeaderText:(NSString *)headerText {
    self.lblHeaderName.text = headerText;
}

@end
