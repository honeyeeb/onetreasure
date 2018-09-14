//
//  OTHomeCategoryViewController.m
//  OneTreasure
//
//  Created by Frederic on 2016/12/1.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTHomeCategoryViewController.h"

#import "OTCategoryDetailViewController.h"
#import "OTNetworkManager.h"
#import "OTCommon.h"
#import "OTCategorySelectModel.h"

#import <YYModel/YYModel.h>
#import <SDWebImage/UIImageView+WebCache.h>


static NSString *const kHomeCategoryCellID                              = @"OTHomeCategoryTableViewCellID";

NSString *const kCategoryDetailSegueID                                  = @"ot_category_select_detail_segue_id";

@interface OTHomeCategoryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSURLSessionDataTask *categoryTask;


@end

@implementation OTHomeCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"分类浏览";
    [self hideEmptyCells];
    [self loadDataSource];
    [self configHeaderRefreshView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([kCategoryDetailSegueID isEqualToString:segue.identifier]) {
        OTCategoryDetailViewController *detailVC = segue.destinationViewController;
        detailVC.cateModel = sender;
        detailVC.fromType = OTCategoryDetailFromTypeCategoryList;
    }
}


- (void)configHeaderRefreshView {
    WEAKSELF
    [self setMJRefreshHeader:^{
        [weakSelf loadDataSource];
    }];
}

#pragma mark - Network

- (void)loadDataSource {
    [self showHUD];
    WEAKSELF
    self.categoryTask = [[OTNetworkManager sharedManager] GET:[URL_HOST stringByAppendingString:URL_ATEGOTY_SELECT] params:nil completion:^(NSDictionary *data, NSString *errMsg) {
        if (!data) {
            [weakSelf showHUDErrorWithStatus:errMsg];
            return ;
        }
        NSArray *categoryData = data[@"data"];
        NSMutableArray *mutCategory = [NSMutableArray array];
        [categoryData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            OTCategorySelectModel *model = [OTCategorySelectModel yy_modelWithJSON:obj];
            if (model) {
                [mutCategory addObject:model];
            }
        }];
        STRONGSELF
        strongSelf.dataSource = [NSMutableArray arrayWithArray:mutCategory];
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.tableView reloadData];
            [strongSelf dismissHUD];
        });
    }];
    [self.categoryTask resume];
}

#pragma mark - UITableViewDelegate/DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHomeCategoryCellID];
    UIImageView *iconimg = [cell viewWithTag:100];
    UILabel *namelab = [cell viewWithTag:110];
    OTCategorySelectModel *model = _dataSource[indexPath.row];
    if (model) {
        NSString *imgurl = model.iconurl;
        if (![imgurl hasPrefix:@"http"]) {
            imgurl = [URL_HOST stringByAppendingString:model.iconurl];
        }
        [iconimg sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:@"good_default"]];
        namelab.text = model.catename;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < _dataSource.count) {
        OTCategorySelectModel *model = _dataSource[indexPath.row];
        
        [self performSegueWithIdentifier:kCategoryDetailSegueID sender:model];
    }
}

- (void)hideEmptyCells {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

@end
