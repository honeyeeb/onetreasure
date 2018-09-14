//
//  OTCategoryDetailViewController.m
//  OneTreasure
//
//  Created by Frederic on 2016/12/1.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTCategoryDetailViewController.h"
#import "OTGoodsDetailViewController.h"

#import "OTCommon.h"
#import "OTNetworkManager.h"
#import "OTGoodsModel.h"
#import "OTCategorySelectModel.h"
#import "OTProgressView.h"
#import "UIView+OTRedious.h"
#import "OTShopCartManager.h"

#import <YYModel/YYModel.h>
#import <SDWebImage/UIImageView+WebCache.h>


NSInteger const kDetailNetworkPageCount                                 = 20;

static NSString *const kCDetailTableID                                  = @"OTCategoryDetailTableViewCellID";

static NSString *const kGoodsDetailSegueID                              = @"ot_category_detail_goods_detail_segue_id";


@interface OTCategoryDetailViewController ()<CAAnimationDelegate>

@property (nonatomic, strong) NSURLSessionDataTask *detailTask;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger currPage;

@property (nonatomic, assign) NSInteger totalCount;
/// 加入购物车结束的位置
@property (nonatomic, assign) CGPoint endPoint;

@end

@implementation OTCategoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _cateModel.catename;
    [self setupDefaultData];
    [self hideEmptyCells];
    
    [self loadDataSource];
    [self prepareRefreshView];
    
    _endPoint = CGPointMake(200, SCREEN_HEIGHT - 20);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupDefaultData {
    _currPage = 1;
    _totalCount = 0;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([kGoodsDetailSegueID isEqualToString:segue.identifier]) {
        OTGoodsDetailViewController *detailVC = segue.destinationViewController;
        detailVC.goodsParam = sender;
    }
}

- (void)prepareRefreshView {
    WEAKSELF
    [self setMJRefreshHeader:^{
        [weakSelf setupDefaultData];
        [weakSelf loadDataSource];
    }];
    [self setMJRefreshFooter:^{
        [weakSelf loadDataSource];
    }];
}

#pragma mark - Network
- (void)loadDataSource {
    if (_totalCount != 0 && _dataSource.count >= _totalCount) {
        
        return;
    }
    [self showHUD];
    WEAKSELF
    NSString *param;
    NSString *url;
    if (OTCategoryDetailFromTypeCategoryList == _fromType) {
        param = [NSString stringWithFormat:@"method=catelist&cateid=%@&pagesize=%ld&pageindex=%ld", _cateModel.cateid, kDetailNetworkPageCount, _currPage];
        url = [URL_HOST stringByAppendingString:URL_ATEGOTY_SELECT];
    } else if (OTCategoryDetailFromTypeBanner == _fromType) {
        // banner来源
        param = [NSString stringWithFormat:@"method=datagoods&flag=%@&pageSize=%ld&pageindex=%ld", _cateModel.cateid, kDetailNetworkPageCount, _currPage];
        url = [URL_HOST stringByAppendingString:URL_HOME_GOODS];
    }
    self.detailTask = [[OTNetworkManager sharedManager] POST:url params:param completion:^(NSDictionary *data, NSString *errMsg) {
        if (data) {
            NSArray *goods = data[@"data"];
            if (goods.count == 0) {
                [weakSelf dismissHUD];
                return ;
            }
            
            /// 是否需要过滤苹果产品，默认过滤
            BOOL unfiltApples = [[NSUserDefaults standardUserDefaults] boolForKey:OT_FILTER_APPLES];
            
            NSMutableArray *mutaGoods = [NSMutableArray array];
            [goods enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                OTGoodsModel *gModel = [OTGoodsModel yy_modelWithJSON:obj];
                if (gModel.typeid.integerValue != 1 || unfiltApples) {
                    // 过滤苹果产品 & 这个就是苹果产品
                    [mutaGoods addObject:gModel];
                }
            }];
            NSInteger total = [data[@"Total"] integerValue];
            STRONGSELF
            strongSelf.totalCount = total;
            if (weakSelf.currPage == 1) {
                // 第一次加载／重新加载
                if (mutaGoods.count >= kDetailNetworkPageCount) {
                    // 还有更多
                    strongSelf.currPage = strongSelf.currPage + 1;
                }
                strongSelf.dataSource = [NSMutableArray arrayWithArray:mutaGoods];
            } else {
                // 添加
                if (mutaGoods.count >= kDetailNetworkPageCount) {
                    // 还有更多
                    strongSelf.currPage = strongSelf.currPage + 1;
                }
                [strongSelf.dataSource addObjectsFromArray:mutaGoods];
            }
            [weakSelf dismissHUD];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf endMJHeaderRefresh];
                [strongSelf endMHFooterRefresh];
                [strongSelf.tableView reloadData];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf endMJHeaderRefresh];
                [weakSelf endMHFooterRefresh];
                [weakSelf showHUDErrorWithStatus:errMsg];
            });
        }
    }];
    [self.detailTask resume];
    
}

#pragma mark - UITableViewDelegate/DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCDetailTableID];
    UIImageView *tagImg = (UIImageView *)[cell viewWithTag:200];
    UIImageView *iconImg = (UIImageView *)[cell viewWithTag:210];
    UILabel *titleLab = (UILabel *)[cell viewWithTag:220];
    OTProgressView *progress = (OTProgressView *)[cell viewWithTag:230];
    UILabel *totalLab = (UILabel *)[cell viewWithTag:240];
    UILabel *percentLab = (UILabel *)[cell viewWithTag:250];
    UIButton *shopBtn = (UIButton *)[cell viewWithTag:260];
    [shopBtn addTarget:self action:@selector(shopcartBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    OTGoodsModel *detail = _dataSource[indexPath.row];
    tagImg.hidden = (detail.zhuanqu == 1);
    NSString *iconurl = detail.imgurl;
    [iconImg sd_setImageWithURL:[NSURL URLWithString:iconurl] placeholderImage:[UIImage imageNamed:@"good_default"]];
    titleLab.text = detail.tilte;
    totalLab.text = [NSString stringWithFormat:@"总需 %ld", detail.gtotail];
    
    [progress setNeedsLayout];
    [progress layoutIfNeeded];
    [progress addRoundedCorners:UIRectCornerAllCorners withRadii:CGSizeMake(2.0, 2.0)];
    progress.progressViewStyle = UIProgressViewStyleBar;
    progress.backgroundColor = [UIColor clearColor];
    progress.trackTintColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
    progress.progressTintColor = [UIColor colorWithRed:0.94 green:0.45 blue:0.29 alpha:1.00];
    
    float prog = detail.cyrs / (detail.gtotail * 1.00 );
    progress.progress = prog;
    percentLab.text = [NSString stringWithFormat:@"%.f%%", prog * 100];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /// 进入详情页面
    OTGoodsModel *detail = _dataSource[indexPath.row];
    if (detail) {
        OTGoodsDetailParam *param = [[OTGoodsDetailParam alloc] init];
        param.goodsID = detail.uuid;
        param.periods = detail.shuji;
        [self performSegueWithIdentifier:kGoodsDetailSegueID sender:param];
        
    }
}

- (void)hideEmptyCells {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

/**
 *  根据cell中的UIButton获取当前cell的index
 *
 *  @param sender 按钮
 *
 *  @return 当前的index
 */
- (NSIndexPath*)getIndexOfCellContentButton:(UIView *)sender {
    if (![sender isKindOfClass:[UIView class]]) {
        return 0;
    }
    UIView * v = sender.superview.superview;
    if (![v isKindOfClass:[UITableViewCell class]]) {
        //ios 8.0以前 需要取三次才能取到 cell
        v = sender.superview.superview.superview;
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)v];
    return indexPath;
}

- (void)addShopCartAnimation:(UIView *)sender {
    
    NSIndexPath *indexPath = [self getIndexOfCellContentButton:sender];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    CGPoint carButtonCenter = sender.center;
    
    //把button在cell坐标转化为在tableView上的坐标
    CGPoint point = [cell convertPoint:carButtonCenter toView:cell.superview];
    
    //起点
    CGPoint startPoint = [self.tableView convertPoint:point toView:self.view];;
    //控点
    CGPoint controlPoint = CGPointMake(_endPoint.x, startPoint.y);
    
    //创建一个layer
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 40, 40);
    layer.position = point;
    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.cornerRadius = layer.frame.size.width/2;
    layer.masksToBounds = YES;
    [self.view.layer addSublayer:layer];
    
    //创建关键帧
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.delegate = self;
    //动画时间
    animation.duration = 0.5;
    
    //当动画完成，停留到结束位置
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    //当方法名字遇到create,new,copy,retain，都需要管理内存
    CGMutablePathRef path = CGPathCreateMutable();
    //设置起点
    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    CGPathAddQuadCurveToPoint(path, NULL, controlPoint.x, controlPoint.y, _endPoint.x, _endPoint.y);
    
    //设置动画路径
    animation.path = path;
    
    //执行动画
    [layer addAnimation:animation forKey:nil];
    
    //释放路径
    CGPathRelease(path);
}

- (void)shopcartBtnAction:(UIButton *)sender {
    /// 加入购物车
    NSInteger row = [self getIndexOfCellContentButton:sender].row;
    if (row >= _dataSource.count) {
        return;
    }
    [self addShopCartAnimation:(UIView *)sender];
    
    OTGoodsModel *goodsModel = _dataSource[row];
    [[OTShopCartManager sharedInstance] addGoods:goodsModel];
}

@end
