//
//  OTGoodsDetailViewController.m
//  OneTreasure
//
//  Created by Frederic on 2016/11/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTGoodsDetailViewController.h"
#import <YYModel/YYModel.h>
#import "OTHomeBannerSubjectView.h"

#import "OTNetworkManager.h"
#import "OTCommon.h"
#import "OTGoodsDetailMoel.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "OTAccountManager.h"
#import "IDMPhotoBrowser.h"
#import "OTGoodsDetailTitleTableViewCell.h"
#import "OTGoodsDetailShopperTableViewCell.h"
#import "OTShopperModel.h"
#import "OTGoodsToolsBar.h"
#import "OTShopCartManager.h"
#import "OTShopCartPayRequest.h"
#import "OTGoodsModel.h"
//#import <SafariServices/SafariServices.h>



typedef NS_ENUM(NSInteger, OTGoodsDetailSectionType) {
    /**商品名称、期号、参与*/
    OTGoodsDetailSectionTypeTitle,
    /**图文详情、揭晓、分享*/
    OTGoodsDetailSectionTypeDetail,
    /**参与记录*/
    OTGoodsDetailSectionTypeShopUsers,
    /// 所有
    OTGoodsDetailSectionTypeAll,
};


static NSString *const kDetailTitlesCellID                      = @"OTGoodsDetailTitleTableViewCellID";

static NSString *const kDetailCellStype1                        = @"OTGoodsDetailInfoTableViewCellID";

static NSString *const kDetailShopperCellID                     = @"OTGoodsDetailShopperTableViewCellID";

NSString *const kDetailSeguetoRechargeID                        = @"ot_goods_detail_recharge_segue_id";


NSInteger kBottomToolBarHeight                                  = 49;
NSInteger kShopperRequestCount                                  = 10;


@implementation OTGoodsDetailParam

- (instancetype)initWithGoodsID:(NSString *)goodsID period:(NSString *)period {
    if (self = [super init]) {
        _goodsID = [goodsID copy];
        _periods = [period copy];
    }
    return self;
}

@end

#pragma mark - 分割

@interface OTGoodsDetailViewController ()<UITableViewDelegate, UITableViewDataSource, OTHomeBannerViewDelegate, IDMPhotoBrowserDelegate, OTGoodsToolBarDelegate>
/// 头部
@property (weak, nonatomic) IBOutlet UIView *naviHeaderView;
/// 返回按钮
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
/// 主view
@property (nonatomic, strong) UITableView *goodstableView;
/// 照片图
@property (nonatomic, strong) OTHomeBannerSubjectView *photoViews;

@property (nonatomic, strong) UIView *shoppperHeaderView;

@property (nonatomic, strong) OTGoodsToolsBar *toolsBarView;

/// 商品详情model
@property (nonatomic, strong) OTGoodsDetailMoel *detailModel;
/// 商品详情的网络请求
@property (nonatomic, strong) NSURLSessionDataTask *detailTask;
/// 获取商品参与者
@property (nonatomic, strong) NSURLSessionDataTask *shopperTask;
/// 图片数据源
@property (nonatomic, strong) NSArray *bannerParamArr;
/// 详情
@property (nonatomic, strong) NSArray *detailInfoArray;
/// 参与人数
@property (nonatomic, strong) NSMutableArray *shopperAray;
/// 当前page
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger totalShoppes;

@end

@implementation OTGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"商品详情";
    
    _detailInfoArray = @[@"图文详情", @"往期揭晓", @"晒单分享"];
    [self setDefaultShopperData];
    [self.view addSubview:self.toolsBarView];
    [self.view addSubview:self.goodstableView];
    [self.view bringSubviewToFront:_naviHeaderView];
    
    [self setTableViewInfo];
    
    [self loadGoodsDetail:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.fd_interactivePopDisabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDefaultShopperData {
    _pageIndex = 1;
    _totalShoppes = 0;
    [_shopperAray removeAllObjects];
}

- (void)reloadGoodsDetails {
    [self setDefaultShopperData];
    [self loadGoodsDetail:NO];
}

- (UITableView *)goodstableView {
    if (!_goodstableView) {
        _goodstableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kBottomToolBarHeight) style:UITableViewStyleGrouped];
        _goodstableView.delegate = self;
        _goodstableView.dataSource = self;
        _goodstableView.backgroundColor = [UIColor clearColor];
        self.tableView = _goodstableView;
    }
    return _goodstableView;
}

- (OTHomeBannerSubjectView *)photoViews {
    if (!_photoViews) {
        _photoViews = [[OTHomeBannerSubjectView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
        _photoViews.delegate = self;
    }
    return _photoViews;
}

- (OTGoodsToolsBar *)toolsBarView {
    if (!_toolsBarView) {
        _toolsBarView = [[OTGoodsToolsBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kBottomToolBarHeight, SCREEN_WIDTH, kBottomToolBarHeight)];
        
        _toolsBarView.delegate = self;
    }
    return _toolsBarView;
}

- (NSMutableArray *)shopperAray {
    if (!_shopperAray) {
        _shopperAray = [NSMutableArray array];
    }
    return _shopperAray;
}

- (void)setTableViewInfo {
    self.tableView.tableHeaderView = self.photoViews;
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kDetailTitlesCellID];
    [self.tableView registerNib:[OTGoodsDetailShopperTableViewCell getNib] forCellReuseIdentifier:kDetailShopperCellID];
    
    WEAKSELF
    [self setMJRefreshHeader:^{
        [weakSelf reloadGoodsDetails];
    }];
    
    [weakSelf setMJRefreshFooter:^{
       
        [weakSelf loadShopperData];
    }];
}

// 返回
- (IBAction)backBtnAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)hasSuperPeriods {
    NSInteger superPeriods = self.detailModel.subperiods;
    return (superPeriods > self.goodsParam.periods.integerValue);
}

- (void)reloadToolsBarData {
    NSArray *titleArr = @[@"加入清单", @"立即参与"];
    
    NSInteger superPeriods = self.detailModel.subperiods;
    if (superPeriods > self.goodsParam.periods.integerValue) {
        NSString *string = [NSString stringWithFormat:@"第%ld期已经开始", (long)superPeriods];
        titleArr = @[string, @"查看"];
        self.toolsBarView.type = OTGoodsDetailToolsTypeFinder;
    } else {
        self.toolsBarView.type = OTGoodsDetailToolsTypeNormal;
    }
    [self.toolsBarView setDataSource:titleArr];
}

#pragma mark - Network

- (void)loadGoodsDetail:(BOOL)show {
    WEAKSELF
    if (show) {
        [self showHUD];
    }
    NSString *params = [NSString stringWithFormat:@"method=iteminfo&id=%@&periods=%@", _goodsParam.goodsID, _goodsParam.periods];
    NSString *userID = [OTAccountManager sharedManger].userID;
    if (userID) {
        params = [params stringByAppendingFormat:@"&uid=%@", userID];
    }
    self.detailTask = [[OTNetworkManager sharedManager] POST:[URL_HOST stringByAppendingString:URL_GOODS_DETAIL] params:params completion:^(NSDictionary *data, NSString *errMsg) {
        if (!data) {
            [weakSelf dismissHUD];
            return ;
        }
        NSArray *result = data[@"data"];
        if (result.count == 0) {
            [weakSelf showHUDErrorWithStatus:kErrorMessage];
            return;
        }
        STRONGSELF
        NSDictionary *detailJson = result[0];
        strongSelf.detailModel = [OTGoodsDetailMoel yy_modelWithJSON:detailJson];
        /// 解析图片数组，用于展示图片
        NSArray *photoArr = detailJson[@"imgurdata"];
        __block NSMutableArray *tmp = [NSMutableArray array];
        [photoArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            OTBannerViewParam *bannerTmp = [OTBannerViewParam yy_modelWithJSON:obj];
            if (bannerTmp) {
                [tmp addObject:bannerTmp];
            }
        }];
        strongSelf.bannerParamArr = [tmp copy];
        
        // 获取参与者
        [strongSelf loadShopperData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf endMJHeaderRefresh];
            [strongSelf reloadToolsBarData];
            
            [strongSelf.tableView reloadData];
            [strongSelf.photoViews setSubjectList:strongSelf.bannerParamArr];
        });
        [strongSelf dismissHUD];
    }];
    [self.detailTask resume];
}

- (void)loadShopperData {
    if (_pageIndex != 1 && _shopperAray.count != 0 && _shopperAray.count > _totalShoppes) {
        // 没有更多了
        return;
    }
    NSString *params = [NSString stringWithFormat:@"method=canyuuser&id=%@&periods=%@&pageindex=%d&pagesize=%d", _goodsParam.goodsID, _goodsParam.periods, (int)_pageIndex, (int)kShopperRequestCount];
    NSString *userID = [OTAccountManager sharedManger].userID;
    if (userID) {
        params = [params stringByAppendingFormat:@"&uid=%@", userID];
    }
    WEAKSELF
    self.shopperTask = [[OTNetworkManager sharedManager] POST:[URL_HOST stringByAppendingString:URL_GOODS_DETAIL] params:params completion:^(NSDictionary *data, NSString *errMsg) {
        NSArray *datas = data[@"data"];
        
        if (datas.count == 0) {
            [weakSelf dismissHUD];
            [weakSelf endMHFooterRefresh];
            return ;
        }
        NSInteger total = [data[@"Total"] integerValue];
        STRONGSELF
        strongSelf.totalShoppes = total;
        
        
        if (datas && [datas isKindOfClass:[NSArray class]]) {
            __block NSMutableArray *shoppes = [NSMutableArray array];
            [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               
                OTShopperModel *shopper = [OTShopperModel yy_modelWithJSON:obj];
                
                if (shopper) {
                    [shoppes addObject:shopper];
                }
            }];
            
            if (strongSelf.pageIndex == 1) {
                // 第一次加载
                strongSelf.shopperAray = [NSMutableArray arrayWithArray:shoppes];
            } else {
                // 上拉更多
                [strongSelf.shopperAray addObjectsFromArray:shoppes];
            }
            if (datas.count >= kShopperRequestCount) {
                strongSelf.pageIndex += 1;
            }
            
        } else {
            // 失败
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [strongSelf endMHFooterRefresh];
            [strongSelf.tableView reloadData];
        });
    }];
    [self.shopperTask resume];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDelegate/DataSource

- (CGFloat)getTitleHeight {
    NSString *text = self.detailModel.prodname;
    CGFloat size = ceilf([text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:16.0] } context:nil].size.height);
    return size + 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == OTGoodsDetailSectionTypeTitle) {
        
        return 0.01;
    } else if (section == OTGoodsDetailSectionTypeShopUsers) {
        
        return 44.0;
    } else if (section == OTGoodsDetailSectionTypeDetail) {
        
        return 0.01;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == OTGoodsDetailSectionTypeTitle) {
        
        return [self getTitleHeight];
    } else if (OTGoodsDetailSectionTypeDetail == indexPath.section) {
        
        return 44.0;
    } else if (OTGoodsDetailSectionTypeShopUsers == indexPath.section) {
        return 60;
    }
    return 10;
}

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView {
    return OTGoodsDetailSectionTypeAll;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == OTGoodsDetailSectionTypeTitle) {
        
        return 2;
    } else if (OTGoodsDetailSectionTypeDetail == section) {
        
        return self.detailInfoArray.count;
    } else if (OTGoodsDetailSectionTypeShopUsers == section) {
        
        return self.shopperAray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == OTGoodsDetailSectionTypeTitle) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDetailTitlesCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDetailTitlesCellID];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = self.detailModel.prodname;
        } else {
            if (self.detailModel.price) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@元", self.detailModel.price];
            }
        }
        
        return cell;
    } else if (indexPath.section == OTGoodsDetailSectionTypeDetail) {
        /// 商品详情
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDetailCellStype1];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kDetailCellStype1];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        }
        NSString *titleString = _detailInfoArray[indexPath.row];
        cell.textLabel.text = titleString;
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = @"建议在Wi-Fi环境查看";
        }
        return cell;
    } else if (indexPath.section == OTGoodsDetailSectionTypeShopUsers) {
        /// 购买记录
        OTGoodsDetailShopperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDetailShopperCellID];
        cell.backgroundColor = [UIColor clearColor];
        cell.shopperModel = self.shopperAray[indexPath.row];
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == OTGoodsDetailSectionTypeDetail) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == OTGoodsDetailSectionTypeDetail) {
        // 详情
        [self segueGoodsDetailWithRow:indexPath.row];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == OTGoodsDetailSectionTypeShopUsers) {
        UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"OTGoodsDetailShopperHeaderViewID"];
        if (!header) {
            header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"OTGoodsDetailShopperHeaderViewID"];
            header.contentView.backgroundColor = [UIColor whiteColor];
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            timeLabel.tag = 200;
            [header addSubview:timeLabel];
        }
        
        UILabel *timeLabel = [header viewWithTag:200];
        if (timeLabel) {
            timeLabel.frame = CGRectMake(15, 0, header.frame.size.width - 20, header.frame.size.height);
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"所有参与记录 " attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:16] }];
            
            if (self.detailModel.createtime) {
                NSAttributedString *timeString = [[NSAttributedString alloc] initWithString:self.detailModel.createtime attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: [UIColor lightGrayColor] }];
                [attrString appendAttributedString:timeString];
            }
            
            timeLabel.attributedText = attrString;
        }
        
        return header;
    }
    return nil;
}

- (void)segueGoodsDetailWithRow:(NSInteger)row {
    if (row >= _detailInfoArray.count) {
        return;
    }
    NSString *urlString = @"";
    NSString *title = _detailInfoArray[row];
    if (row == 0) {
        urlString = [URL_HOST stringByAppendingFormat:@"%@?itemid=%@", URL_GOODS_DETAIL_IMGS, _goodsParam.goodsID];
        
    } else if(row == 1) {
        urlString = [URL_HOST stringByAppendingFormat:@"%@?itemid=%@&ver=4.0", URL_GOODS_LUCK_HISTORY, _goodsParam.goodsID];
        
    } else {
        urlString = [URL_HOST stringByAppendingFormat:@"%@?itemid=%@", URL_GOODS_SHAR, _goodsParam.goodsID];
        
    }
    if ([OTAccountManager sharedManger].userID) {
        urlString = [urlString stringByAppendingFormat:@"&uid=%@", [OTAccountManager sharedManger].userID];
    }
    
    [self segueToWebViewWithURLString:urlString title:title];
}

#pragma mark - OTHomeBannerViewDelegate
- (void)didSelectedHomeBannerCellIndex:(NSInteger)index {
    
    __block NSMutableArray *array = [NSMutableArray array];
    [self.bannerParamArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        OTBannerViewParam *banner = (OTBannerViewParam *)obj;
        IDMPhoto *photo = [[IDMPhoto alloc] initWithURL:[NSURL URLWithString:banner.imgurl]];
        if (photo) {
            [array addObject:photo];
        }
    }];
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:array animatedFromView:self.photoViews];
    browser.delegate = self;
    browser.usePopAnimation = YES;
    [self presentViewController:browser animated:YES completion:NULL];
}

#pragma mark - OTGoodsToolBarDelegate

- (NSString *)getShopPayParams {
    NSString *params;
    OTShopCartPayRequest *request = [[OTShopCartPayRequest alloc] init];
    request.productID = self.goodsParam.goodsID;
    request.qishu = self.goodsParam.periods;
    request.price = self.detailModel.price;
    request.productNumber = @"1";
    NSDictionary *dic = [request yy_modelToJSONObject];
    if (dic) {
        NSArray *array = @[dic];
        NSError *jsonErr;
        NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&jsonErr];
        if (jsonErr) {
            OTLog(@"【购物车支付，转JSON】%@", jsonErr);
        }
        if (data) {
            params = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    }
    
    return params;
}

- (OTGoodsModel *)getOTGoodsModel {
    OTGoodsModel *goods = [[OTGoodsModel alloc] init];
    goods.shuji = self.detailModel.periods;
    goods.price = self.detailModel.price;
    goods.status = self.detailModel.status;
    goods.cyrs = 1;
    goods.uuid = self.goodsParam.goodsID;
    goods.zhuanqu = self.detailModel.zhuanqu;
    goods.imgurl = self.detailModel.gmianimgurl;
    goods.tilte = self.detailModel.prodname;
    
    return goods;
}

- (void)segueToRechargeView {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 去充值
        [self performSegueWithIdentifier:kDetailSeguetoRechargeID sender:nil];
    });
}

- (void)confirmPay {
    WEAKSELF
    [[OTAccountManager sharedManger] accountSignInSuccess:^{
        // 已经登陆
        [weakSelf showHUD];
        
        NSString *param = [weakSelf getShopPayParams];
        [[OTShopCartManager sharedInstance] directPayWithPatams:param completion:^(NSInteger code, NSString *errMsg) {
            if (code == 101) {
                // 余额不足
                [weakSelf showHUDErrorWithStatus:@"您的余额不足"];
                [weakSelf segueToRechargeView];
                
            } else if(code == 0) {
                // 成功
                [weakSelf showHUDSuccessWithStatus:@"获得一次幸运机会"];
                
            } else {
                // 失败
                [weakSelf showHUDErrorWithStatus:errMsg];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf reloadGoodsDetails];
            });
        }];
    } failed:^{
        // 未登录
        [weakSelf segueToSignInViewController];
    }];
}

- (void)didSelectedIndex:(NSInteger)index {
    if (index == 2) {
        if ([self hasSuperPeriods]) {
            // 查看下一期
            self.goodsParam.periods = [NSString stringWithFormat:@"%ld", (long)self.detailModel.subperiods];
            [self setDefaultShopperData];
            [self loadGoodsDetail:YES];
        } else {
            // 立即参与
            if ([[NSUserDefaults standardUserDefaults] boolForKey:OT_ENABLE_DIRECT_PURCHAGE]) {
                [self confirmPay];
            } else {
                NSString *urlString = self.detailModel.url;
                if (urlString) {
                    NSURL *url;
                    if ([urlString hasPrefix:@"http"]) {
                        url = [NSURL URLWithString:urlString];
                    } else {
                        url = [NSURL URLWithString:[URL_HOST stringByAppendingString:urlString]];
                    }
//                    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
//                    [self presentViewController:safariVC animated:YES completion:nil];
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }
    } else {
        // 加入清单
        OTGoodsModel *goods = [self getOTGoodsModel];
        if (goods) {
            [[OTShopCartManager sharedInstance] addGoods:goods];
            [self showHUDSuccessWithStatus:@"成功加入清单"];
        } else {
            [self showHUDErrorWithStatus:kErrorMessage];
        }
    }
}

@end
