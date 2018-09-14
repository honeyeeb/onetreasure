//
//  OTFinderViewController.m
//  OneTreasure
//
//  Created by Frederic on 2016/11/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTFinderViewController.h"

#import "OTGoodsDetailViewController.h"
#import "OTFinderGoodsCollectionViewCell.h"

#import "OTCommon.h"
#import "OTFinderGoodsModel.h"
#import "OTNetworkManager.h"
#import <YYModel/YYModel.h>
#import <MJRefresh/MJRefresh.h>
#import "OTStatistics.h"


static NSString *const kFinderGoodsCellID                       = @"OTFinderCollectionViewCellID";

/// 页面转场(到中奖商品详情页)
NSString *const kFinderGoodsDetailSegueID                       = @"ot_findervc_goods_detailvc_segue_id";


#define kItemWidth                                              ( (SCREEN_WIDTH - 1.0) / 2.0 )
#define kItemsHeight                                            ( kItemWidth * 11 / 8 )
NSInteger const kFinderGoodsPageSize                            = 20;


@interface OTFinderViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/// 数据源
@property (nonatomic, strong) NSMutableArray *goodsDataSource;
/// 当前页码，分页
@property (nonatomic, assign) NSInteger currentPage;
/// 总共的页码
@property (nonatomic, assign) NSInteger totalGoodsCount;
/// 网络任务
@property (nonatomic, strong) NSURLSessionDataTask *goodsTask;

@property (nonatomic, assign) BOOL shouldShowHUD;

@end

@implementation OTFinderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.collectionView registerNib:[OTFinderGoodsCollectionViewCell getNib] forCellWithReuseIdentifier:kFinderGoodsCellID];
    self.title = @"最新揭晓";
    _shouldShowHUD = YES;
    [self setDefaultProperty];
    [self configHeaderRefreshView];
    [self configFooterRefreshView];
    [self loadFinderGoods];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _shouldShowHUD = YES;
    if (self.goodsDataSource.count > 0) {
        [self.collectionView reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _shouldShowHUD = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDefaultProperty {
    _currentPage = 1;
    _totalGoodsCount = 0;
}

- (void)configHeaderRefreshView {
    WEAKSELF
    [self setMJRefreshHeader:^{
        [weakSelf setDefaultProperty];
        [weakSelf loadFinderGoods];
    }];
}

- (void)configFooterRefreshView {
    WEAKSELF
    [self setMJRefreshFooter:^{
        [weakSelf loadFinderGoods];
    }];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([kFinderGoodsDetailSegueID isEqualToString:segue.identifier]) {
        OTGoodsDetailViewController *detailVC = segue.destinationViewController;
        detailVC.goodsParam = sender;
    }
}

#pragma mark - Network
- (void)loadFinderGoods {
    if (self.totalGoodsCount !=0 && self.goodsDataSource.count >= self.totalGoodsCount) {
        // 到底了，没有数据了
        return;
    }
    WEAKSELF
    if (_shouldShowHUD) {
        [self showHUD];
    }
    /// 是否需要过滤苹果产品，默认过滤
    BOOL unfiltApples = [[NSUserDefaults standardUserDefaults] boolForKey:OT_FILTER_APPLES];
    NSString *params = [NSString stringWithFormat:@"method=jsjxload&pageindex=%ld&pageSize=%ld", (long)_currentPage, kFinderGoodsPageSize];
    self.goodsTask = [[OTNetworkManager sharedManager] POST:[URL_HOST stringByAppendingString:URL_FINDER_GOODS] params:params completion:^(NSDictionary *data, NSString *errMsg) {
        if (data) {
            NSArray *result = data[@"data"];
            if (result.count == 0) {
                
                return;
            }
            NSMutableArray *mutaGoods = [NSMutableArray array];
            [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                OTFinderGoodsModel *model = [OTFinderGoodsModel yy_modelWithJSON:obj];
                if (model.typeid.integerValue != 1 || unfiltApples) {
                    [mutaGoods addObject:model];
                }
            }];
            NSInteger total = [data[@"Total"] integerValue];
            STRONGSELF
            strongSelf.totalGoodsCount = total;
            if (weakSelf.currentPage == 1) {
                // 第一次加载／重新加载
                if (mutaGoods.count >= kFinderGoodsPageSize) {
                    // 还有更多
                    strongSelf.currentPage = strongSelf.currentPage + 1;
                }
                strongSelf.goodsDataSource = [NSMutableArray arrayWithArray:mutaGoods];
            } else {
                // 添加
                if (mutaGoods.count >= kFinderGoodsPageSize) {
                    // 还有更多
                    strongSelf.currentPage = strongSelf.currentPage + 1;
                }
                [strongSelf.goodsDataSource addObjectsFromArray:mutaGoods];
            }
            [weakSelf dismissHUD];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf endMJHeaderRefresh];
                [strongSelf endMHFooterRefresh];
                [strongSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
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

/// 倒计时结束
- (void)countDownFinishAction:(OTFinderGoodsModel *)model {
    if (model) {
        NSString *params = [NSString stringWithFormat:@"method=jxupdate&itemid=%@&qishu=%@", model.itemid, model.periods];
        WEAKSELF;
        NSURLSessionDataTask *countTast = [[OTNetworkManager sharedManager] GET:[URL_HOST stringByAppendingString:URL_COUNT_DOWN_FINISH] params:params completion:^(NSDictionary *data, NSString *errMsg) {
            [weakSelf setDefaultProperty];
            [weakSelf loadFinderGoods];
        }];
        [countTast resume];
    }
}

#pragma UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OTFinderGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFinderGoodsCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.goodsModel = self.goodsDataSource[indexPath.row];
    WEAKSELF;
    cell.countDownFinish = ^(OTFinderGoodsModel *goods) {
        [weakSelf countDownFinishAction:goods];
    };
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kItemWidth, kItemsHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    /// 进入商品详情
    OTFinderGoodsModel *model = self.goodsDataSource[indexPath.row];
    if (model) {
        OTGoodsDetailParam *param = [[OTGoodsDetailParam alloc] initWithGoodsID:model.itemid period:model.periods];
        [self performSegueWithIdentifier:kFinderGoodsDetailSegueID sender:param];
        
        NSDictionary *dic = [param yy_modelToJSONObject];
        if (dic) {
            [OTStatistics event:@"ot_finder_goods_detail" attributes:dic];
        }
    }
}


@end
