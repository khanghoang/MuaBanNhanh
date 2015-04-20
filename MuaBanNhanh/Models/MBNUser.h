//
//  MBNUser.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MTLModel.h"

typedef enum : NSUInteger {
    MBNUserTypeBasic,
    MBNUserTypePremium,
} MBNUserType;

typedef enum : NSUInteger {
    MBNUserValidatePhoneNumberNo,
    MBNUserValidatePhoneNumberYes,
} MBNUserValidatePhoneNumber;

@interface MBNUser : MTLModel
<
MTLJSONSerializing
>

@property (copy, nonatomic) NSNumber *ID;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *gender;
@property (copy, nonatomic) NSURL *avatarImageUrl;
@property (copy, nonatomic) NSURL *coverImageUrl;
@property (assign, nonatomic) BOOL isValidatePhoneNumber;
@property (copy, nonatomic) NSString *accountType;
@property (copy, nonatomic) NSString *token;

@property (copy, nonatomic) NSString *identity;
@property (copy, nonatomic) NSDate *createAt;
@property (copy, nonatomic) NSString *about;

@end
