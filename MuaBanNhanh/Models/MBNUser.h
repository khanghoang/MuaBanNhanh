//
//  MBNUser.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MTLModel.h"

@interface MBNUser : MTLModel
<
MTLJSONSerializing
>

@property (copy, nonatomic) NSNumber *ID;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSURL *avatarImageUrl;
@property (copy, nonatomic) NSURL *coverImageUrl;

@end
