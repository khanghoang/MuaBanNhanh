//
//  UIImageView+LoadingImage.m
//  FoxPlay
//
//  Created by Triệu Khang on 7/7/14.
//  Copyright (c) 2014 2359Media. All rights reserved.
//

#import "UIImageView+LoadingImage.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

static const NSInteger kLoadingViewTag = 10;

@implementation UIImageView (LoadingImage)

- (void)fp_setImageWithURL:(NSURL *)url {
    if (!url) {
        return;
    }

    NSURLRequest *requestImage = [NSURLRequest requestWithURL:url];

    UIImage *cachedImage = [[UIImageView sharedImageCache] cachedImageForRequest:requestImage];
    if (cachedImage) {
        [self setImage:cachedImage];
        return;
    }

    UIView *loadingContainer = [self.superview viewWithTag:kLoadingViewTag];
    if (!loadingContainer) {
        UIView *superView = self.superview;
        loadingContainer = [[UIView alloc] initWithFrame:self.frame];
        
        UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loading startAnimating];
        loading.frame = CGRectMake(0, 0, 15, 15);
        
        [loadingContainer setTag:kLoadingViewTag];
        [loadingContainer addSubview:loading];
        loadingContainer.backgroundColor = [UIColor clearColor];
        
        [loading mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(loadingContainer);
            make.width.equalTo(@(15));
            make.height.equalTo(@(15));
        }];
        
        [superView addSubview:loadingContainer];
        
        [loadingContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self setNeedsUpdateConstraints];
        [self layoutIfNeeded];
    }

    __weak typeof(self) weakSelf = self;

    [self setImageWithURLRequest:requestImage placeholderImage:nil success: ^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf setImage:image];
        [UIView animateWithDuration:0.5 animations: ^{
            loadingContainer.alpha = 0;
        } completion: ^(BOOL finished) {
            [loadingContainer removeFromSuperview];
        }];
    } failure: ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        // TODO: should replace this with broken thumbnail.
    }];
}

@end
