//
//  MBNSiteInformationViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 6/15/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNSiteInformationViewController.h"
#import <TTTAttributedLabel.h>

@interface MBNSiteInformationViewController ()

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *staticLabel;

@end

@implementation MBNSiteInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://api1.muabannhanh.com/home/statistics" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *productCount = responseObject[@"result"][@"article_count"];
        NSString *productCountString = [MBNProduct getPriceDisplayString:productCount];
        NSString *userCount = responseObject[@"result"][@"user_count"];
        NSString *userCountString = [MBNProduct getPriceDisplayString:userCount];
        
        NSString *text = [NSString stringWithFormat:@"Có %@ tin đăng và %@ thành viên", productCountString, userCountString];
        
        [self.staticLabel setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            NSRange boldRange1 = [text rangeOfString:userCountString];
            NSRange boldRange2 = [text rangeOfString:productCountString];
            UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:14];
            
            CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
            
            UIColor *greenColor = [UIColor colorFromHexString:@"#49b050"];
            if (font) {
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange1];
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange2];
                [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)greenColor.CGColor range:boldRange1];
                [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)greenColor.CGColor range:boldRange2];
                CFRelease(font);
            }
            
            return mutableAttributedString;
            
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

@end
