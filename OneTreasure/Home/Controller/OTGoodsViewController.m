//
//  OTGoodsViewController.m
//  OneTreasure
//
//  Created by Frederic on 2016/11/23.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTGoodsViewController.h"

#import "OTHomeBannerSubjectView.h"
#import "OTHomeGoodsCollectionViewCell.h"
#import "OTHomeNoticeView.h"
#import "OTHomeCategoryView.h"
#import "OTGoodsDetailViewController.h"
#import "OTCategoryDetailViewController.h"
#import "OTHomeBannerCollectionCell.h"

#import "OTHomeBannerMode.h"
#import "OTNoticeModel.h"
#import "OTGoodsModel.h"
#import "OTHomeCategoryModel.h"
#import "OTNetworkManager.h"
#import "OTCommon.h"
#import "OTCategorySelectModel.h"
#import <YYModel/YYModel.h>
#import <MJRefresh/MJRefresh.h>
#import "OTShopCartManager.h"
#import "OTStatistics.h"
#import "OTStatementView.h"


/// collection cell 类型
typedef NS_ENUM(NSInteger, OTHomeCollectionCellType) {
    /// 广告
    OTHomeCollectionCellTypeBanner,
    /// 通告
    OTHomeCollectionCellTypeNotice,
    /// 分类
    OTHomeCollectionCellTypeCategory,
    /// 商品
    OTHomeCollectionCellTypeGoods,
    /// 所有
    OTHomeCollectionCellTypeAll,
};

#define kItemWidth                                      (SCREEN_WIDTH - 0.5) / 2.0
#define kItemsHeight                                    kItemWidth * 5 / 4

#define kBannerItemHeight                                ( SCREEN_WIDTH * 3 / 8 )
NSInteger kGoodsPageSize                          = 20;

NSInteger const kCategoryViewHeight                     = 40;

static NSString *const kHomeBanndeGoodsCellID           = @"OTHomeBannerCollectionViewCellID";
static NSString *const kHomeNoticeCellID                = @"OTHomeNoticeCollectionViewCellID";
static NSString *const kHomeGoodsCellID                 = @"OTHomeGoodsCollectionViewCellID";
static NSString *const kHomeCategoryCellID              = @"OTHomeCategoryCoolectionViewCellID";

NSString *const HomeGoodsDetailSegueID                  = @"ot_homegoods_goodsdetail_segue_id";
NSString *const HomeBannerCategoryDetailSegueID         = @"ot_homebanner_categorydetail_segue_id";


@interface OTGoodsViewController ()<UICollectionViewDelegate,
                                    UICollectionViewDataSource,
                                    UICollectionViewDelegateFlowLayout,
                                    OTHomeBannerViewDelegate,
                                    OTNotifiViewDelegate,
                                    OTHomeCategoryViewDelegate,
                                    OTHomeGoodsCollectionCellDelegate,
                                    UIViewControllerPreviewingDelegate>

/// 通知
@property (strong, nonatomic) OTHomeNoticeView *noticeView;
/// 分类
@property (strong, nonatomic) OTHomeCategoryView *categoryView;

/// 苹果声明
@property (nonatomic, strong) OTStatementView *statementView;

/// Title
//@property (strong, nonatomic) UIView *homeNavView;

/// 商品数据源
@property (strong, nonatomic) NSMutableArray *goodsDataSource;

/// 广告数据源
@property (strong, nonatomic) NSArray *bannerDataSource;
@property (strong, nonatomic) NSArray *bannerParams;

/// 通知数据源
@property (strong, nonatomic) NSArray *noticeDataSource;

/// 商品的请求对象
@property (strong, nonatomic) NSURLSessionDataTask *goodsTask;

/// 选择的展示方式
@property (assign, nonatomic) OTGoodsSortType goodsSortType;

/// 分类下商品的总数，用于分页加载计算
@property (assign, nonatomic) NSInteger totalGoodsCount;
/// 当前页数，分也加载
@property (assign, nonatomic) NSInteger currentPage;

@end


@implementation OTGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationItem.titleView = self.homeNavView;
    self.title = OT_APP_NAME;
    
    [self registerCollectionViewCell];
    [self defaultPropertys];
    [self loadGoodsDatas];
    
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [weakSelf loadBannerDatas];
        [weakSelf loadNoticeDatas];
    });
    [self.view addSubview:self.statementView];
    [self.view bringSubviewToFront:self.statementView];
    
    [self loadEnablePerchase];
    
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.collectionView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)defaultPropertys {
    _goodsSortType = OTGoodsSortTypePopulay;
    _currentPage = 1;
    _totalGoodsCount = 0;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([HomeGoodsDetailSegueID isEqualToString:segue.identifier]) {
        // 商品详情
        OTGoodsDetailViewController *detailVC = segue.destinationViewController;
        detailVC.goodsParam = sender;
    } else if ([HomeBannerCategoryDetailSegueID isEqualToString:segue.identifier]) {
        // 广告到分类详情页
        OTCategoryDetailViewController *categoryVC = segue.destinationViewController;
        categoryVC.fromType = OTCategoryDetailFromTypeBanner;
        categoryVC.cateModel = sender;
    }
}

//- (UIView *)homeNavView {
//    if (!_homeNavView) {
//        _homeNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
//        CGPoint center = _homeNavView.center;
//        UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//        logoImg.center = center;
//        logoImg.image = [UIImage imageNamed:@"splash_logo"];
//        [_homeNavView addSubview:logoImg];
//    }
//    return _homeNavView;
//}

- (OTHomeNoticeView *)noticeView {
    if (!_noticeView) {
        _noticeView = [[OTHomeNoticeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _noticeView.delegate = self;
    }
    return _noticeView;
}

- (OTHomeCategoryView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[OTHomeCategoryView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kCategoryViewHeight)];
        _categoryView.delegate = self;
    }
    return _categoryView;
}

- (OTStatementView *)statementView {
    if (!_statementView) {
        _statementView = [[OTStatementView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49 - 64 - 30, SCREEN_WIDTH, 30)];
        WEAKSELF
        _statementView.StatementCloseAction = ^{
            [weakSelf.statementView removeFromSuperview];
        };
    }
    return _statementView;
}

- (void)registerCollectionViewCell {
    [self.collectionView registerClass:[OTHomeBannerCollectionCell class] forCellWithReuseIdentifier:kHomeBanndeGoodsCellID];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kHomeNoticeCellID];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kHomeCategoryCellID];
    [self.collectionView registerNib:[OTHomeGoodsCollectionViewCell getNib] forCellWithReuseIdentifier:kHomeGoodsCellID];
    [self configHeaderRefreshView];
    [self configFooterRefreshView];
}

- (void)configHeaderRefreshView {
    WEAKSELF
    [self setMJRefreshHeader:^{
        [weakSelf defaultPropertys];
        [weakSelf loadGoodsDatas];
        [weakSelf loadBannerDatas];
        [weakSelf loadNoticeDatas];
    }];
}

- (void)configFooterRefreshView {
    WEAKSELF
    [self setMJRefreshFooter:^{
        [weakSelf loadGoodsDatas];
    }];
    
}

#pragma mark - Networks

- (void)loadBannerDatas {
    WEAKSELF
    NSURLSessionDataTask *task = [[OTNetworkManager sharedManager] GET:[URL_HOST stringByAppendingString:URL_HOME_BANNER] params:nil completion:^(NSDictionary *data, NSString *errMsg) {
        if (data != nil) {
            NSArray *banners = data[@"data"];
            if (!banners || banners.count == 0) {
                return ;
            }
            STRONGSELF
            NSMutableArray *models = [NSMutableArray array];
            NSMutableArray *baPas = [NSMutableArray array];
            // NOTE
            NSArray *tmpBanner = [NSArray arrayWithObject:banners[0]];
            [tmpBanner enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                OTHomeBannerMode *model = [OTHomeBannerMode yy_modelWithJSON:obj];
                OTBannerViewParam *baP = [OTBannerViewParam yy_modelWithJSON:obj];
                if (model) {
                    [models addObject:model];
                }
                if (baP) {
                    [baPas addObject:baP];
                }
            }];
            strongSelf.bannerDataSource = [NSArray arrayWithArray:models];
            strongSelf.bannerParams = [NSArray arrayWithArray:baPas];
            dispatch_async(dispatch_get_main_queue(), ^{
//                [strongSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:OTHomeCollectionCellTypeBanner]]];
                [strongSelf.collectionView reloadData];
            });
        }
    }];
    [task resume];
}

- (void)loadNoticeDatas {
    WEAKSELF
    NSURLSessionDataTask *task =  [[OTNetworkManager sharedManager] GET:[URL_HOST stringByAppendingString:URL_HOME_NOTICE] params:nil completion:^(NSDictionary *data, NSString *errMsg) {
        if (data) {
            NSArray *notices = data[@"data"];
            NSMutableArray *models = [NSMutableArray array];
            [notices enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                OTNoticeModel *notice = [OTNoticeModel yy_modelWithJSON:obj];
                if (notice) {
                    [models addObject:notice];
                }
            }];
            STRONGSELF
            strongSelf.noticeDataSource = [NSArray arrayWithArray:models];
            dispatch_async(dispatch_get_main_queue(), ^{
//                [strongSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:OTHomeCollectionCellTypeNotice]]];
                [strongSelf.collectionView reloadData];
            });
        }
    }];
    
    [task resume];
}

- (void)loadGoodsDatas {
    if (self.totalGoodsCount !=0 && self.goodsDataSource.count >= self.totalGoodsCount) {
        // 到底了，没有数据了
        return;
    }
    WEAKSELF
    if (self.goodsDataSource.count > 0) {
        [self showHUD];
    }
    NSString *sortName = [OTHomeCategoryModel getGoodsSortName:_goodsSortType];
    NSString *params = [NSString stringWithFormat:@"method=datagoods&pageindex=%ld&pageSize=%ld&flag=%@", (long)_currentPage, kGoodsPageSize , sortName];
    self.goodsTask = [[OTNetworkManager sharedManager] POST:[URL_HOST stringByAppendingString:URL_HOME_GOODS] params:params completion:^(NSDictionary *data, NSString *errMsg) {
        if (data) {
            NSArray *goods = data[@"data"];
            if (goods.count == 0) {
                [weakSelf dismissHUD];
                return ;
            }
            STRONGSELF
            NSMutableArray *mutaGoods = [NSMutableArray array];
            /// 是否需要过滤苹果产品，默认过滤
            BOOL unfiltApples = [[NSUserDefaults standardUserDefaults] boolForKey:OT_FILTER_APPLES];
            if (!unfiltApples) {
                kGoodsPageSize = 1;
            }
            [goods enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                OTGoodsModel *gModel = [OTGoodsModel yy_modelWithJSON:obj];
                if (gModel.typeid.integerValue != 1 || unfiltApples) {
                    // 过滤苹果产品 & 这个就是苹果产品
                    [mutaGoods addObject:gModel];
                }
            }];
            NSInteger total = [data[@"Total"] integerValue];
            strongSelf.totalGoodsCount = total;
            if (weakSelf.currentPage == 1) {
                // 第一次加载／重新加载
                if (mutaGoods.count >= kGoodsPageSize) {
                    // 还有更多
                    strongSelf.currentPage = strongSelf.currentPage + 1;
                }
                strongSelf.goodsDataSource = [NSMutableArray arrayWithArray:mutaGoods];
            } else {
                // 添加
                if (mutaGoods.count >= kGoodsPageSize) {
                    // 还有更多
                    strongSelf.currentPage = strongSelf.currentPage + 1;
                }
                [strongSelf.goodsDataSource addObjectsFromArray:mutaGoods];
            }
            [weakSelf dismissHUD];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf endMJHeaderRefresh];
                [strongSelf endMHFooterRefresh];
//                [strongSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:OTHomeCollectionCellTypeGoods]];
                // TODO 刷新
                [strongSelf.collectionView reloadData];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf endMJHeaderRefresh];
                [weakSelf endMHFooterRefresh];
                [weakSelf showHUDErrorWithStatus:errMsg];
            });
            
        }
    }];
    [self.goodsTask resume];
}

- (void)loadEnablePerchase {
    
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSString *params = [NSString stringWithFormat:@"method=ctlversion&version=%@&bundleid=%@", app_version, bundleID];
    NSURLSessionDataTask *task = [[OTNetworkManager sharedManager] POST:[URL_HOST stringByAppendingString:URL_HOME_GOODS] params:params completion:^(NSDictionary *data, NSString *errMsg) {
        BOOL flag = [[NSString stringWithFormat:@"%@", data[@"canPurchase"]] boolValue];
        [[NSUserDefaults standardUserDefaults] setBool:flag forKey:OT_ENABLE_DIRECT_PURCHAGE];
        BOOL fileFlag = [[NSString stringWithFormat:@"%@", data[@"showApple"]] boolValue];
        [[NSUserDefaults standardUserDefaults] setBool:fileFlag forKey:OT_FILTER_APPLES];
    }];
    [task resume];
}

/// 进入商品详情页
- (void)pushViewGoodsDetail:(OTGoodsDetailParam *)params {
    if (params) {
        
        [self performSegueWithIdentifier:HomeGoodsDetailSegueID sender:params];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return OTHomeCollectionCellTypeAll;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == OTHomeCollectionCellTypeGoods) {
        return self.goodsDataSource.count;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == OTHomeCollectionCellTypeBanner) {
        OTHomeBannerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeBanndeGoodsCellID forIndexPath:indexPath];
        cell.delegate = self;
        cell.bannerView.subjectList = self.bannerParams;
        
        return cell;
    } else if (indexPath.section == OTHomeCollectionCellTypeNotice) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeNoticeCellID forIndexPath:indexPath];
        [cell addSubview:self.noticeView];
        self.noticeView.dataArray = self.noticeDataSource;
        
        return cell;
    } else if (indexPath.section == OTHomeCollectionCellTypeCategory) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCategoryCellID forIndexPath:indexPath];
        [cell addSubview:self.categoryView];
        self.categoryView.cateList = [OTHomeCategoryModel getDefaultCategorys];
        [self.categoryView collectionViewScrollToCellIndex:_goodsSortType - 1];
        
        return cell;
    }
    else {
        OTHomeGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeGoodsCellID forIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.delegate = self;
        [cell setGoodsModel:self.goodsDataSource[indexPath.row] indexPath:indexPath];
        
        return cell;
    }
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == OTHomeCollectionCellTypeBanner) {
        return CGSizeMake(SCREEN_WIDTH, kBannerItemHeight);
    } else if(indexPath.section == OTHomeCollectionCellTypeNotice) {
        return CGSizeMake(SCREEN_WIDTH, 40);
    } else if(indexPath.section == OTHomeCollectionCellTypeCategory) {
        return CGSizeMake(SCREEN_WIDTH, kCategoryViewHeight);
    }
        return CGSizeMake(kItemWidth, kItemsHeight);
}

- (void)didSelectGoodsIndexPath:(NSIndexPath *)indexPath {
    // 商品详情页
    OTGoodsModel *goodsModel = self.goodsDataSource[indexPath.row];
    OTGoodsDetailParam *params = [[OTGoodsDetailParam alloc] initWithGoodsID:goodsModel.uuid period:goodsModel.shuji];
    [self pushViewGoodsDetail:params];
    
    // 统计
    NSDictionary *dic = [goodsModel statisticsJSON];
    if (dic) {
        [OTStatistics event:@"ot_home_goods_click" attributes:dic];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self didSelectGoodsIndexPath:indexPath];
}

// 设置如下三个代理方法，使cell自动适应屏幕大小
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_WIDTH, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == OTHomeCollectionCellTypeGoods) {
        return CGSizeMake(SCREEN_WIDTH, 20);
    } else if (section == OTHomeCollectionCellTypeCategory) {
        return CGSizeMake(SCREEN_WIDTH, 0.5);
    }
        return CGSizeMake(SCREEN_WIDTH, 8);
}

#pragma mark - OTHomeGoodsCollectionCellDelegate
- (void)didClickShopCartBtnIndexPath:(NSIndexPath *)indexPath {
    // 加入清单
    if (indexPath.row >= self.goodsDataSource.count) {
        return;
    }
    OTGoodsModel *goodsModel = self.goodsDataSource[indexPath.row];
    if (goodsModel) {
        OTLog(@"===加入清单%@", goodsModel.tilte);
        [[OTShopCartManager sharedInstance] addGoods:goodsModel];
    }
}

#pragma mark - OTHomeBannerViewDelegate

- (void)didSelectedHomeBannerCellIndex:(NSInteger)index {
    if (index >= self.bannerDataSource.count) {
        return;
    }
    OTHomeBannerMode *banner = self.bannerDataSource[index];
    if (banner.type == 2) {
        // 如果有外链地址，就跳转到web页面
        [self segueToWebViewWithURLString:banner.gourl title:banner.tilte];
        
    } else if (banner.type == 1) {
        // 内部筛选
        OTCategorySelectModel *categoryModel = [[OTCategorySelectModel alloc] init];
        categoryModel.catename = banner.tilte;
        categoryModel.cateid = banner.clienturl;
        [self performSegueWithIdentifier:HomeBannerCategoryDetailSegueID sender:categoryModel];
    }
    
    // 统计
    NSDictionary *dic = [banner yy_modelToJSONObject];
    if (dic) {
        [OTStatistics event:@"ot_home_banner_click" attributes:dic];
    }
}

#pragma mark - OTNotifiViewDelegate

- (void)didSelectedNoticeCellIndexPath:(NSIndexPath *)indexPath {
    OTNoticeModel *notice = self.noticeDataSource[indexPath.row];
    if (notice) {
        OTGoodsDetailParam *detailParam = [[OTGoodsDetailParam alloc] initWithGoodsID:notice.itemid period:notice.periods];
        [self pushViewGoodsDetail:detailParam];
        
        // 统计
        NSDictionary *dic = [notice yy_modelToJSONObject];
        if (dic) {
            [OTStatistics event:@"ot_home_notice_click" attributes:dic];
        }
    }
}

#pragma mark - OTHomeCategoryViewDelegate
- (void)didSelectHomeCategoryViewItemIndex:(NSInteger)index {
    _goodsSortType = index + 1;
    _currentPage = 1;
    _totalGoodsCount = 0;
    [self loadGoodsDatas];
}

#pragma mark - UIViewControllerPreviewingDelegate
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    if (indexPath.section == OTHomeCollectionCellTypeGoods) {
        // 商品
        OTGoodsModel *goodsModel = self.goodsDataSource[indexPath.row];
        OTGoodsDetailParam *params = [[OTGoodsDetailParam alloc] initWithGoodsID:goodsModel.uuid period:goodsModel.shuji];
        OTGoodsDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"OTGoodsDetailViewController"];
        detailVC.goodsParam = params;
        
        return detailVC;
    }
    
    return nil;
}
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self.navigationController pushViewController:viewControllerToCommit animated:YES];
}

@end
