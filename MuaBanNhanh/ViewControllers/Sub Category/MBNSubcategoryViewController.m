//
//  MBNSubcategoryViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/8/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNSubcategoryViewController.h"
#import "MBNSubcategoryTableViewCell.h"
#import "MBNCategoryProductsViewController.h"

@interface MBNSubcategoryViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UITableView *tableViewSubcategories;
@property (strong, nonatomic) MBNSubcategoryTableViewCell *prototypeCell;

@end

@implementation MBNSubcategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.tableViewSubcategories.rowHeight = UITableViewAutomaticDimension;
//    self.tableViewSubcategories.estimatedRowHeight = 44.0;
}

- (MBNSubcategoryTableViewCell *)prototypeCell {
    if (!_prototypeCell) {
        _prototypeCell = [self.tableViewSubcategories dequeueReusableCellWithIdentifier:NSStringFromClass([MBNSubcategoryTableViewCell class])];
    }
    
    return _prototypeCell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableViewSubcategories reloadData];
}

#pragma mark - Tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrSubcategories.count;
}

- (MBNSubcategoryTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MBNSubcategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MBNSubcategoryTableViewCell class])];
    [cell configWithData:self.arrSubcategories[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        return UITableViewAutomaticDimension;
    }
    
    MBNSubcategoryTableViewCell *cell = self.prototypeCell;
    [cell configWithData:self.arrSubcategories[indexPath.row]];
    [cell updateConstraintsIfNeeded];
    [cell layoutIfNeeded];
    return [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

#pragma marks - delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"MBNSegueShowProductFromCategory"]) {
        NSIndexPath *indexPath = [self.tableViewSubcategories indexPathForSelectedRow];
        MBNCategory *cat = self.arrSubcategories[indexPath.row];
        MBNCategoryProductsViewController *vc = segue.destinationViewController;
        vc.category = cat;
        vc.title = cat.name;
    }
}

@end
