//
//  MBNCategory.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/1/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MTLModel.h"

@interface MBNCategory : MTLModel
<
MTLJSONSerializing
>

@property (copy, nonatomic) NSNumber *ID;
@property (copy, nonatomic) NSNumber *parentID;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *slug;
@property (copy, nonatomic) NSURL *imageUrl;
@property (copy, nonatomic) NSURL *imageHoverUrl;
@property (copy, nonatomic) NSNumber *ordering;
@property (copy, nonatomic) NSNumber *articleCount;
@property (strong, nonatomic) NSArray *subCategories;

@end
