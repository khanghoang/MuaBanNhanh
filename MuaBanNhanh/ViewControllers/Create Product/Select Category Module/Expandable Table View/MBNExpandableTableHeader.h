//
//  MBNExpandableTableHeader.h
//  MuaBanNhanh
//
//  Created by iSlan on 4/29/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBNExpandableTableHeader : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIButton *headerSelectedButton;
@property (weak, nonatomic) IBOutlet UILabel *headerNameLabel;
@property (weak, nonatomic) IBOutlet UIView *headerSeparatorView;

@end
