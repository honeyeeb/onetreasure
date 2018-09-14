//
//  OTBaseTableViewController.m
//  OneTreasure
//
//  Created by Frederic on 2016/11/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTBaseTableViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface OTBaseTableViewController ()

@end

@implementation OTBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MJRefresh
- (void)setMJRefreshHeader:(void (^)())block {
    if (!self.tableView) {
        return;
    }
    __unsafe_unretained UIScrollView *mjScrollView = self.tableView;
    // 下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:block];
    header.lastUpdatedTimeLabel.hidden = YES;
    mjScrollView.mj_header = header;
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    mjScrollView.mj_header.automaticallyChangeAlpha = YES;
}
- (void)setMJRefreshFooter:(void (^)())block  {
    if (!self.tableView) {
        return;
    }
    __unsafe_unretained UIScrollView *mjScrollView = self.tableView;
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:block];
    footer.refreshingTitleHidden = YES;
    mjScrollView.mj_footer = footer;
}

- (void)endMJHeaderRefresh {
    if (!self.tableView) {
        return;
    }
    [self.tableView.mj_header endRefreshing];
}

- (void)endMHFooterRefresh {
    if (!self.tableView) {
        return;
    }
    [self.tableView.mj_footer endRefreshing];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
