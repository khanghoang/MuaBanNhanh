//
//  TMECameraFilterSelectorVC.m
//  ThreeMin
//
//  Created by Khoa Pham on 11/19/14.
//  Copyright (c) 2014 3min. All rights reserved.
//

#import "TMECameraFilterSelectorVC.h"
#import "TMESingleSectionDataSource.h"
#import "TMECameraFilterCell.h"
#import "TMECameraFilter.h"

#import "IMGLYFilterOperation.h"
#import "IMGLYOperation.h"
#import "IMGLYKit.h"

@interface TMECameraFilterSelectorVC ()

@property (nonatomic, strong) TMESingleSectionDataSource *dataSource;
@property (nonatomic, strong) NSArray *filtersTypes;
@property (nonatomic, strong) NSArray *filters;
@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation TMECameraFilterSelectorVC

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.queue = dispatch_queue_create("TMECameraFilterSelectorVCQueue", DISPATCH_QUEUE_SERIAL);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
    [self setupFilters];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup
- (void)setupCollectionView
{
    self.dataSource = [[TMESingleSectionDataSource alloc] init];
    self.dataSource.cellIdentifier = [TMECameraFilterCell kind];

    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];

    __weak typeof (self) weakSelf = self;
    self.dataSource.detailCellConfigureBlock = ^(TMECameraFilterCell *cell, TMECameraFilter *filter, NSIndexPath *indexPath) {
        [cell.filterImageButton addTarget:weakSelf action:@selector(filterButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [cell.filterImageButton setImage:filter.image forState:UIControlStateNormal];
        cell.filterLabel.text = filter.filterName;

        cell.activeOverlayImageView.hidden = ![weakSelf.selectedIndexPath isEqual:indexPath];
    };

    self.collectionView.dataSource = self.dataSource;
}

- (void)setupFilters
{
    dispatch_async(self.queue, ^{
        UIImage *staticImage = [UIImage imageNamed:@"static_filter_image"];
        [[IMGLYPhotoProcessor sharedPhotoProcessor] setInputImage:staticImage];

        NSMutableArray *filters = [NSMutableArray array];
        for (NSNumber *filterTypeNumber in self.filtersTypes) {
            TMECameraFilter *filter = [[TMECameraFilter alloc] init];
            filter.filterType = filterTypeNumber.integerValue;
            filter.filterName = [self filterNameFromType:filter.filterType];

            IMGLYProcessingJob *job = [[IMGLYProcessingJob alloc] init];
            IMGLYFilterOperation *operation = [[IMGLYFilterOperation alloc] init];
            operation.filterType = filter.filterType;
            [job addOperation:(IMGLYOperation *)operation];
            [[IMGLYPhotoProcessor sharedPhotoProcessor] performProcessingJob:job];

            filter.image = [[IMGLYPhotoProcessor sharedPhotoProcessor] outputImage];

            [filters addObject:filter];
        }

        self.filters = filters;

        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataSource.items = self.filters;
            [self.collectionView reloadData];
        });
    });
}

#pragma mark - Public Interface
- (void)reset
{
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.collectionView reloadData];
}

#pragma mark - Delegate
- (void)didSelectFilterType:(IMGLYFilterType)filterType
{
    if ([self.delegate respondsToSelector:@selector(filterSelectorVCDidSelectFilterType:)]) {
        [self.delegate filterSelectorVCDidSelectFilterType:filterType];
    }
}

#pragma mark - Action
- (void)filterButtonTouched:(UIButton *)button
{
    CGPoint pointInCollectionView = [self.collectionView convertPoint:button.center fromView:button];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointInCollectionView];;

    if ([self.selectedIndexPath isEqual:indexPath]) {
        return;
    }

    self.selectedIndexPath = indexPath;
    [self.collectionView reloadData];

    TMECameraFilter *filter = self.dataSource.items[indexPath.row];
    [self didSelectFilterType:filter.filterType];
}

#pragma mark - Filter
- (NSArray *)filtersTypes
{
    if (!_filtersTypes) {
        _filtersTypes = @[
                          @(IMGLYFilterTypeNone),
                          @(IMGLYFilterType9EK1),
                          @(IMGLYFilterType9EK6),
                          @(IMGLYFilterType9EKDynamic),
                          @(IMGLYFilterTypeFridge),
                          @(IMGLYFilterTypeBreeze),
                          @(IMGLYFilterTypeChestnut),
                          @(IMGLYFilterTypeFront),
                          @(IMGLYFilterTypeFixie),
                          @(IMGLYFilterTypeBW),
                          @(IMGLYFilterTypeBWHard),
                          @(IMGLYFilterTypeLenin),
                          @(IMGLYFilterTypeQouzi),
                          @(IMGLYFilterType669),
                          @(IMGLYFilterTypePola),
                          @(IMGLYFilterTypeFood),
                          @(IMGLYFilterTypeGlam),
                          @(IMGLYFilterTypeLord),
                          @(IMGLYFilterTypeTejas),
                          @(IMGLYFilterTypeLomo),
                          @(IMGLYFilterTypeSketch),
                          @(IMGLYFilterTypeMellow),
                          @(IMGLYFilterTypeSunny),
                          @(IMGLYFilterTypeA15),
                          ];

        // TODO: Avoid memory warning by use less filters
        if (!IS_RETINA) {
            _filters = [_filters subarrayWithRange:NSMakeRange(0, 4)];
        }
    }

    return _filtersTypes;
}

- (NSString *)filterNameFromType:(IMGLYFilterType)filterType
{
    switch (filterType) {
        case IMGLYFilterTypeNone:
            return @"None";
        case IMGLYFilterType9EK1:
            return @"K1";
        case IMGLYFilterType9EK2:
            return @"K2";
        case IMGLYFilterType9EK6:
            return @"K6";
        case IMGLYFilterType9EKDynamic:
            return @"Dynamic";
        case IMGLYFilterTypeFridge:
            return @"Fridge";
        case IMGLYFilterTypeBreeze:
            return @"Breeze";
        case IMGLYFilterTypeOchrid:
            return @"Orchrid";
        case IMGLYFilterTypeChestnut:
            return @"Chestnut";
        case IMGLYFilterTypeFront:
            return @"Front";
        case IMGLYFilterTypeFixie:
            return @"Fixie";
        case IMGLYFilterTypeX400:
            return @"X400";
        case IMGLYFilterTypeBW:
            return @"BW";
        case IMGLYFilterTypeBWHard:
            return @"1920";
        case IMGLYFilterTypeLenin:
            return @"Lenin";
        case IMGLYFilterTypeQouzi:
            return @"Qouzi";
        case IMGLYFilterType669:
            return @"Pola 669";
        case IMGLYFilterTypePola:
            return @"Pola SX";
        case IMGLYFilterTypeFood:
            return @"Food";
        case IMGLYFilterTypeGlam:
            return @"Glam";
        case IMGLYFilterTypeLord:
            return @"Lord";
        case IMGLYFilterTypeTejas:
            return @"Tejas";
        case IMGLYFilterTypeEarlyBird:
            return @"Morning";
        case IMGLYFilterTypeLomo:
            return @"Lomo";
        case IMGLYFilterTypeGobblin:
            return @"Gobblin";
        case IMGLYFilterTypeSinCity:
            return @"Sin";
        case IMGLYFilterTypeSketch:
            return @"Sketch";
        case IMGLYFilterTypeMellow:
            return @"Mellow";
        case IMGLYFilterTypeSunny:
            return @"Sunny";
        case IMGLYFilterTypeA15:
            return @"A15";
        case IMGLYFilterTypeSemiRed:
            return @"Semi Red";
        default:
            return nil;
    }
}

@end
