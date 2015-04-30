//
//  MBNMangeProductCellFactory.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/30/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "KHSuperCollectionCellFactory.h"
#import <KHTableViewController/KHSuperCollectionCellFactory.h>
#import <KHTableViewController/KHCollectionViewCellFactoryProtocol.h>

@interface MBNMangeProductCellFactory : KHSuperCollectionCellFactory
<
KHCollectionViewCellFactoryProtocol
>

@property (strong, nonatomic) void (^tapMenuButtonActionBlock)(NSIndexPath *selectedIndexPath, UIButton *menuButton);

@end
