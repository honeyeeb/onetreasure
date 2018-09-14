//
//  OTShopCartViewController.m
//  OneTreasure
//
//  Created by Frederic on 2016/11/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTShopCartViewController.h"

#import "OTShopCartEmptyView.h"
#import "OTShopCartPriceView.h"
#import "OTShopCartRecommendHeaderView.h"
#import "OTShopCartShopsTableViewCell.h"
#import "OTShopCartRecommendTableViewCell.h"
#import "OTGoodsDetailViewController.h"

#import "OTCommon.h"
#import "OTShopCartManager.h"
#import "OTNetworkManager.h"
#import "OTGoodsModel.h"
#import <YYModel/YYModel.h>
#import "OTAccountManager.h"
#import "OTStatistics.h"


/// 底端 支付 控件高度
NSInteger const kBottomPriceViewHeight                                          = 50;

NSInteger const kShopCartNormalCellHeight                                       = 95;

NSInteger const kShopCartHeaderHeight                                           = 260;

static NSString *const kShopCartListTableViewCellID                             = @"OTShopCartListTableViewCellID";
static NSString *const kShopCartRecommendCellID                                 = @"OTShopCartRecommendTableViewCellID";
static NSString *const kShopCartEmptyHeaderViewID                               = @"OTShopCartTableViewHeaderID";
static NSString *const kShopCartRecommendHeaderID                               = @"OTShopCartRecommendHeaderID";

NSString *const OTShopCartGoodsDetailSegueID                                    = @"ot_shopcart_goods_detail_segue_id";
NSString *const OTShopCartRechargeSegueID                                       = @"ot_shop_cart_recharge_segue_id";


@interface OTShopCartViewController ()<UITableViewDelegate, UITableViewDataSource, OTShopCartPriceViewDelegate, OTShopCartRecommendCellDelegate, OTShopCartShopCellDelegate>

/// 价格／结算
@property (nonatomic, strong) OTShopCartPriceView *priceView;
/// 空的购物车提示
@property (nonatomic, strong) OTShopCartEmptyView *emptyHeaderView;

/// 推荐商品数据源
@property (nonatomic, strong) NSMutableArray *recommendDataSource;

/// 请求推荐列表
@property (nonatomic, strong) NSURLSessionDataTask *recommendTask;

@property (nonatomic, assign, getter=isDeleting) BOOL deleting;


@end

@implementation OTShopCartViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"清单";
    
    // 购物车数量变化，刷新页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopCartListChanged:) name:kOTShopCartCountPriceNotification object:nil];
    
    [self loadShopListData];
    
    [self setupTableViews];
    [self.view addSubview:self.priceView];
    
    [self loadRecommendDatas];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updatePayView];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kOTShopCartCountPriceNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (OTShopCartPriceView *)priceView {
    if (!_priceView) {
        CGRect frame = CGRectMake(0, SCREEN_HEIGHT - kBottomPriceViewHeight - 49 - 64, SCREEN_WIDTH, kBottomPriceViewHeight);
        _priceView = [[OTShopCartPriceView alloc] initWithFrame:frame];
        _priceView.delegate = self;
    }
    return _priceView;
}

- (NSMutableArray *)recommendDataSource {
    if (!_recommendDataSource) {
        _recommendDataSource = [NSMutableArray array];
    }
    return _recommendDataSource;
}

- (OTShopCartEmptyView *)emptyHeaderView {
    if (!_emptyHeaderView) {
        _emptyHeaderView = [[OTShopCartEmptyView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        WEAKSELF
        _emptyHeaderView.emptyShopAction = ^{
            /// 马上去购物
            weakSelf.tabBarController.selectedIndex = 0;
        };
    }
    return _emptyHeaderView;
}

- (void)setupTableViews {
    [self hideEmptyCells];
    
    [self.tableView registerNib:[OTShopCartShopsTableViewCell getNib] forCellReuseIdentifier:kShopCartListTableViewCellID];
    [self.tableView registerClass:[OTShopCartRecommendTableViewCell class] forCellReuseIdentifier:kShopCartRecommendCellID];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, kBottomPriceViewHeight, 0)];
    
    WEAKSELF
    [self setMJRefreshHeader:^{
        
        [weakSelf loadRecommendDatas];
    }];
}

/// 加载购物车内商品
- (void)loadShopListData {
    
    
}
/// 加载推荐商品
- (void)loadRecommendDatas {
    
    [self showHUD];
    WEAKSELF;
    self.recommendTask = [[OTNetworkManager sharedManager] GET:[URL_HOST stringByAppendingString:URL_RECOMMEND_GOODS] params:nil completion:^(NSDictionary *data, NSString *errMsg) {
        if (data) {
            NSArray *results = data[@"data"];
            NSMutableArray *tmpArr = [NSMutableArray array];
            OTLog(@"【推荐】%@", results);
            /// 是否需要过滤苹果产品，默认过滤
            BOOL unfiltApples = [[NSUserDefaults standardUserDefaults] boolForKey:OT_FILTER_APPLES];
            [results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                OTGoodsModel *model = [OTGoodsModel yy_modelWithJSON:obj];
                if (model.typeid.integerValue != 1 || unfiltApples) {
                    // 过滤苹果产品 & 这个就是苹果产品
                    [tmpArr addObject:model];
                }
            }];
            weakSelf.recommendDataSource = [NSMutableArray arrayWithArray:tmpArr];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf endMJHeaderRefresh];
                [weakSelf dismissHUD];
                [weakSelf.tableView reloadData];
                
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf endMJHeaderRefresh];
                [weakSelf showHUDErrorWithStatus:kErrorMessage];
            });
        }
    }];
    [self.recommendTask resume];
}

/**
 *  更新支付页面数据,价钱、数量、是否全选；如果价钱/数量＝0隐藏
 *
 */
- (void)updatePayView {
    
    // 隐藏/显示空的header view
    BOOL isEmptyShopList = [OTShopCartManager sharedInstance].totalCount.integerValue == 0;
    self.emptyHeaderView.hidden = !isEmptyShopList;
    
    // 隐藏／显示价格页面
    WEAKSELF
    [UIView animateWithDuration:1.0 animations:^{
        weakSelf.priceView.hidden = isEmptyShopList;
    }];
    
    if (!isEmptyShopList) {
        NSArray *selctedArray = [OTShopCartManager sharedInstance].selectedIDArray;
        // 显示价格／数量
        NSString *price = [OTShopCartManager sharedInstance].selectedPrice;
        NSInteger count = selctedArray.count;
        [self.priceView setTotalPriceTextWithPrice:price];
        [self.priceView setPayButtonText:count];
        [self.priceView setSelectAll:[OTShopCartManager sharedInstance].paySelectedAll];
    }
    
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}
/// 删除购物车内商品
- (void)deleteShopListGoodsWithIndex:(NSIndexPath *)indexPath {
    
    [[OTShopCartManager sharedInstance] removeGoodsWithIndex:indexPath.row];
}

#pragma mark - UITableViewDelegate/DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kShopCartNormalCellHeight;
    }
    return [OTShopCartRecommendTableViewCell getCellHeightWithDataSourceCount:self.recommendDataSource.count];
}

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [[OTShopCartManager sharedInstance].totalCount integerValue];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        OTShopCartShopsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShopCartListTableViewCellID];
        cell.delegate = self;
        cell.indexPath = indexPath;
        OTGoodsModel *model = [OTShopCartManager sharedInstance].shopCartArray[indexPath.row];
        [cell setGoodsModel:model];
        // 按钮选中状态
        NSArray *selectdArr = [OTShopCartManager sharedInstance].selectedIDArray;
        [cell setSelectedBtnSelected:[selectdArr containsObject:model]];
        
        return cell;
        
    } else if(indexPath.section == 1) {
        OTShopCartRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShopCartRecommendCellID];
        cell.delegate = self;
        [cell setRecommendDataSource:self.recommendDataSource];
        
        return cell;
    } else {
        static NSString *empty = @"OTEmptyID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:empty];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:empty];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return YES;
    }
    return NO;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                         title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                             // 删除
                                                                             [weakSelf deleteShopListGoodsWithIndex:indexPath];
                                                                             
                                                                         }];
    
    rowAction.backgroundColor = RGB_COLOR(248, 108, 108, 1.0);
    
    NSArray *arr = @[rowAction];
    return arr;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 50;
    }
    return ([[OTShopCartManager sharedInstance].totalCount integerValue] > 0 ? 0.1 : kShopCartHeaderHeight);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kShopCartEmptyHeaderViewID];
        if (!headerView) {
            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kShopCartEmptyHeaderViewID];
            [headerView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, kShopCartHeaderHeight)];
            [headerView.contentView setBackgroundColor:[UIColor clearColor]];
            [headerView addSubview:self.emptyHeaderView];
            self.emptyHeaderView.center = headerView.center;
        }
        return headerView;
    } else if (section == 1) {
        OTShopCartRecommendHeaderView *recommend = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kShopCartRecommendHeaderID];
        if (!recommend) {
            recommend = [[OTShopCartRecommendHeaderView alloc] initWithReuseIdentifier:kShopCartRecommendHeaderID];
            recommend.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
            recommend.contentView.backgroundColor = [UIColor clearColor];
        }
        return recommend;
    }
    return nil;
}

- (void)hideEmptyCells {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

- (void)segueToRechargeView {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 去充值
        [self performSegueWithIdentifier:OTShopCartRechargeSegueID sender:nil];
    });
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([OTShopCartGoodsDetailSegueID isEqualToString:segue.identifier]) {
        OTGoodsDetailViewController *detailVC = segue.destinationViewController;
        detailVC.goodsParam = sender;
    }
}


#pragma mark - Notifications
/// 购物车数量变化
- (void)shopCartListChanged:(NSNotification *)notifi {
    
    [self updatePayView];
    
}

#pragma mark - OTShopCartPriceViewDelegate

- (void)shopCartSubmitOrderBtnAction {
    if (self.tableView.isEditing || [OTShopCartManager sharedInstance].selectedIDArray.count == 0) {
        return;
    }
    WEAKSELF
    [[OTAccountManager sharedManger] accountSignInSuccess:^{
        // 已经登陆
        if (![[NSUserDefaults standardUserDefaults] boolForKey:OT_ENABLE_DIRECT_PURCHAGE]) {
            OTGoodsModel *goods = [[OTShopCartManager sharedInstance] shopCartArray][0];
            NSString *urlStr = [NSString stringWithFormat:@"https://qyweb.josmob.com:8336/item.htm?id=%@&periods=%@", goods.uuid, goods.shuji];
            NSURL *url = [NSURL URLWithString:urlStr];
            [[UIApplication sharedApplication] openURL:url];
            
        } else {
            // 苹果审核通过
            [weakSelf showHUD];
            [[OTShopCartManager sharedInstance] payResuestCompletion:^(NSInteger code, NSString *errMsg) {
                if (code == 101) {
                    // 余额不足
                    [weakSelf showHUDSuccessWithStatus:errMsg];
                    [weakSelf segueToRechargeView];
                    
                } else if(code == 0) {
                    // 成功
                    [weakSelf showHUDSuccessWithStatus:@"购买成功"];
                    [[OTShopCartManager sharedInstance] removeAllGoods];
                    
                } else {
                    // 失败
                    [weakSelf showHUDErrorWithStatus:errMsg];
                }
            }];
        }
        
    } failed:^{
        // 未登录
        [weakSelf segueToSignInViewController];
    }];
    
}

- (void)shopCartSelectedAllBtnAction {
    if (self.tableView.isEditing) {
        return;
    }
    BOOL isSelectAll = [OTShopCartManager sharedInstance].paySelectedAll;
    [[OTShopCartManager sharedInstance] setPaySelectedAll:!isSelectAll];
    [self updatePayView];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - OTShopCartRecommendCellDelegate

- (void)goodsDetailSegue:(OTGoodsModel *)model {
    if (model) {
        OTGoodsDetailParam *param = [[OTGoodsDetailParam alloc] initWithGoodsID:model.uuid period:model.shuji];
        [self performSegueWithIdentifier:OTShopCartGoodsDetailSegueID sender:param];
        
        // 统计
        NSDictionary *dic = [model yy_modelToJSONObject];
        if (dic) {
            [OTStatistics event:@"ot_shop_cart_recommend_goods" attributes:dic];
        }
    }
}

- (void)didSelectGoodsIndexPath:(NSIndexPath *)indexPath {
    OTGoodsModel *model = self.recommendDataSource[indexPath.row];
    [self goodsDetailSegue:model];
}
/// 购物车
- (void)didClickShopCartBtnIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > self.recommendDataSource.count) {
        return;
    }
    OTGoodsModel *goodsModel = self.recommendDataSource[indexPath.row];
    [[OTShopCartManager sharedInstance] addGoods:goodsModel];
}

#pragma mark - OTShopCartShopCellDelegate

- (void)normalCellActionWithModel:(OTGoodsModel *)model type:(OTShopCartNormalCellActionType)type indexPath:(NSIndexPath *)indexPath {
    if (!model) {
        return;
    }
    if (type == OTShopCartNormalCellActionTypeDetail) {
        // 详细
        [self goodsDetailSegue:model];
    } else if (type == OTShopCartNormalCellActionTypeSubtract) {
        // 减
        [[OTShopCartManager sharedInstance] subtractGoods:model];
    } else if (type == OTShopCartNormalCellActionTypeAdd) {
        // 加
        
        [[OTShopCartManager sharedInstance] addGoods:model];
    } else if (type == OTShopCartNormalCellActionTypeSelect) {
        // 选中
        
        [[OTShopCartManager sharedInstance] selectOrDeselectGoodsWithIndex:indexPath.row];
        
        // 价格
        [self updatePayView];
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end
