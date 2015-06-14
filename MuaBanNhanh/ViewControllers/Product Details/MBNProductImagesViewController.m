//
//  MBNProductImagesViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/25/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNProductImagesViewController.h"
#import "MBNProductImageCell.h"

@interface MBNProductImagesViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIScrollViewDelegate
>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) SMPageControl *pageControl;

@end

@implementation MBNProductImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SMPageControl *pageControl = [[SMPageControl alloc] init];
    pageControl.pageIndicatorImage = [UIImage imageNamed:@"page-indicator"];
    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"page-indicator-selected"];
    pageControl.numberOfPages = 0;
    [pageControl sizeToFit];
    [self.view addSubview:pageControl];
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(pageControl.width));
        make.height.equalTo(@15);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(20);
    }];
    
    self.pageControl = pageControl;
    
    @weakify(self);
    [[RACObserve(self, viewModel) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
        self.pageControl.numberOfPages = self.viewModel.product.gallery.count;
        [self.pageControl sizeToFit];
        [self.pageControl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(pageControl.width));
        }];
        [self.view layoutIfNeeded];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = ceil(scrollView.contentOffset.x / scrollView.bounds.size.width);
    [self.pageControl setCurrentPage:index];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        return CGSizeMake(self.collectionView.width, self.collectionView.height);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.product.gallery.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MBNProductImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MBNProductImageCell class]) forIndexPath:indexPath];
    [cell configWithData:self.viewModel.product.gallery[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *gallery = self.viewModel.product.gallery;
    
    // Create an array to store IDMPhoto objects
    NSMutableArray *photos = [NSMutableArray new];
    
    for (MBNImage *image in gallery) {
        IDMPhoto *photo = [IDMPhoto photoWithURL:image.imageURL];
        photo.caption = image.caption;
        [photos addObject:photo];
    }
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
    [browser setInitialPageIndex:indexPath.row];
    [self presentViewController:browser animated:YES completion:nil];
}

@end
