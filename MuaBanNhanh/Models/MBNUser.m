//
//  MBNUser.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNUser.h"

@implementation MBNUser


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"ID": @"id",
             @"name": @"name",
             @"phone": @"phone",
             @"email": @"email",
             @"gender": @"gender",
             @"isValidatePhoneNumber": @"phone_number_certified",
             @"accountType": @"type",
             @"token": @"token",
             @"avatarImageUrl": @"avatar_image_url",
             @"coverImageUrl": @"cover_image_url",
             };
}

+ (NSValueTransformer *)avatarImageUrlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)coverImageUrlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)isValidatePhoneNumberJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.ID forKey:@"id"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.phone forKey:@"phone"];
    [coder encodeObject:self.email forKey:@"email"];
    [coder encodeObject:@(self.isValidatePhoneNumber) forKey:@"isValidatePhoneNumber"];
    [coder encodeObject:self.accountType forKey:@"accountType"];
    [coder encodeObject:self.token forKey:@"token"];
    [coder encodeObject:self.avatarImageUrl forKey:@"avatarImageUrl"];
    [coder encodeObject:self.coverImageUrl forKey:@"coverImageUrl"];
}

- (id)initWithCoder:(NSCoder *)coder {
    
    if (self = [super init]) {
        self.ID = [coder decodeObjectForKey:@"ID"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.phone = [coder decodeObjectForKey:@"phone"];
        self.email = [coder decodeObjectForKey:@"email"];
        self.isValidatePhoneNumber = [[coder decodeObjectForKey:@"isValidatePhoneNumber"] boolValue];
        self.accountType = [coder decodeObjectForKey:@"accountType"];
        self.token = [coder decodeObjectForKey:@"token"];
        self.avatarImageUrl = [coder decodeObjectForKey:@"avatarImageUrl"];
        self.coverImageUrl = [coder decodeObjectForKey:@"coverImageUrl"];
    }
    
    return self;
    
}

@end
