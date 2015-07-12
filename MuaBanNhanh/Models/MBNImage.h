//
//  MBNImage.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/25/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MTLModel.h"

@interface MBNImage : MTLModel
<
MTLJSONSerializing
>

@property (copy, nonatomic) NSNumber *ID;
@property (copy, nonatomic) NSString *caption;
@property (copy, nonatomic) NSString *imageFileName;
@property (copy, nonatomic) NSURL *imageURL;

@end
