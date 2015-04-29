//
//  MBNCreateProductViewModel.h
//  MuaBanNhanh
//
//  Created by iSlan on 4/28/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MBNProductTransactionType) {
    MBNProductTransactionTypeSelling = 0,
    MBNProductTransactionTypeBuying,
};

@interface MBNCreateProductViewModel : NSObject

@property (copy, nonatomic) NSString *productTitle;
@property (copy, nonatomic) NSString *productDescription;
@property (copy, nonatomic) NSString *productQuality;
@property (copy, nonatomic) NSString *productPrice;
@property (copy, nonatomic) NSArray *provinces;
@property (copy, nonatomic) NSArray *productQualityTitles;
@property (copy, nonatomic) NSArray *productTransactionTypeTitles;
@property (copy, nonatomic) NSArray *pickedCategories;

@property (copy, nonatomic) NSString *getProvincesErrorMessage;
@property (assign, nonatomic) NSInteger provinceSelectedIndex;
@property (assign, nonatomic) NSInteger productQualitySelectedIndex;
@property (assign, nonatomic) NSInteger productTransactionTypeSelectedIndex;
@property (assign, nonatomic) MBNProductTransactionType productTransactionType;

- (void)getProvinces;

@end
