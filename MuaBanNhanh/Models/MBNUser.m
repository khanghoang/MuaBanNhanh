//
//  MBNUser.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNUser.h"

@implementation MBNUser

- (id)copyWithZone:(NSZone *)zone {
    MBNUser *user = [super copyWithZone:zone];
    return user;
}


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"ID": @"id",
             @"name": @"name",
             @"phone": @"phone",
             @"email": @"email",
             @"gender": @"gender",
             @"isValidatePhoneNumber": @"phone_number_certified",
             @"accountType": @"type",
             @"birthday": @"birthday",
             @"token": @"token",
             @"avatarImageUrl": @"avatar_image_url",
             @"coverImageUrl": @"cover_image_url",
             @"identity": @"identity_number",
             @"createAt": @"created_at",
             @"about": @"about",
             @"address": @"address.address"
             
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
    [coder encodeObject:self.ID forKey:@"ID"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.phone forKey:@"phone"];
    [coder encodeObject:self.email forKey:@"email"];
    [coder encodeObject:@(self.isValidatePhoneNumber) forKey:@"isValidatePhoneNumber"];
    [coder encodeObject:self.accountType forKey:@"accountType"];
    [coder encodeObject:self.token forKey:@"token"];
    [coder encodeObject:self.avatarImageUrl forKey:@"avatarImageUrl"];
    [coder encodeObject:self.coverImageUrl forKey:@"coverImageUrl"];
    
    [coder encodeObject:self.identity forKey:@"identity"];
    [coder encodeObject:self.createAt forKey:@"createAt"];
    [coder encodeObject:self.about forKey:@"about"];
    [coder encodeObject:self.address forKey:@"address"];
    [coder encodeObject:self.address forKey:@"birthday"];
}

+ (NSValueTransformer *)createAtJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *dateString) {
        NSDateFormatter *formatter = [self sharedDateFormatter];
        return [formatter dateFromString:dateString];
    } reverseBlock:^(NSDate *date) {
        return [date description];
    }];
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
        
        self.identity = [coder decodeObjectForKey:@"identity"];
        self.createAt = [coder decodeObjectForKey:@"createAt"];
        self.about = [coder decodeObjectForKey:@"about"];
        self.address = [coder decodeObjectForKey:@"adress"];
        self.birthday = [coder decodeObjectForKey:@"birthday"];
    }
    
    return self;
    
}

#pragma marks - Helper methods 

+ (NSDateFormatter *)sharedDateFormatter
{
    static NSDateFormatter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NSDateFormatter alloc] init];
        instance.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        [instance setTimeZone:[[NSTimeZone alloc] initWithName:@"UTC"]];
    });

    return instance;
}


@end
