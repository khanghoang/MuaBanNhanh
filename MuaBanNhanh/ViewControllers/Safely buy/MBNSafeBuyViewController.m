//
//  MBNSafeBuyViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/18/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNSafeBuyViewController.h"
#import "MBNSafeBuyCollectionCell.h"

@interface MBNSafeBuyViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIScrollViewDelegate
>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *arrData;
@property (strong, nonatomic) SMPageControl *pageControl;

@end

@implementation MBNSafeBuyViewController

- (NSArray *)arrData {
    if (!_arrData) {
        _arrData = @[
                     @{
                         @"image": @"Step 1",
                         @"text": @"Nên giao dịch ở những nơi công cộng hoặc các địa điểm an toàn."
                         },
                     @{
                         @"image": @"Step 2",
                         @"text": @"Hạn chế việc trả tiền trước cho người bán mà bạn không biết."
                         },
                     @{
                         @"image": @"Step 3",
                         @"text": @"Không nên đặt niềm tin với người bán khi chưa kiểm chứng thông tin được cung cấp."
                         },
                     @{
                         @"image": @"Step 4",
                         @"text": @"Không bao giờ gửi hàng hoá trước khi hoàn tất thoả thuận thanh toán."
                         },
                     @{
                         @"image": @"Step 5",
                         @"text": @"Kiểm tra hàng hoá cẩn thận, đặc biệt khi mua hàng cũ, đã qua sử dụng."
                         },
                     @{
                         @"image": @"Step 6",
                         @"text": @"Yêu cầu biên nhận, phiếu thu hoặc giấy tay về việc mua bán nếu có thể."
                         },
                     ];
    }
    
    return _arrData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.collectionView reloadData];
    
    SMPageControl *pageControl = [[SMPageControl alloc] init];
    pageControl.numberOfPages = self.arrData.count;
    pageControl.pageIndicatorImage = [UIImage imageNamed:@"page-indicator"];
    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"page-indicator-selected"];
    [pageControl sizeToFit];
    [self.view addSubview:pageControl];
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(pageControl.width));
        make.height.equalTo(@15);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-20);
    }];
    
    self.pageControl = pageControl;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = ceil(scrollView.contentOffset.x / scrollView.bounds.size.width);
    [self.pageControl setCurrentPage:index];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionView.bounds.size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MBNSafeBuyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MBNSafeBuyCollectionCell class]) forIndexPath:indexPath];
    [cell configWithData:self.arrData[indexPath.row]];
    return cell;
}

- (IBAction)onBtnClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
