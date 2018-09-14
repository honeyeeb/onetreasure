//
//  OTShopCartRecommendTableViewCell.h
//  OneTreasure
//
//  Created by Frederic on 2016/12/10.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//
//  猜你喜欢，为你推荐


#import "OTBaseTableViewCell.h"

@class OTGoodsModel;

@protocol OTShopCartRecommendCellDelegate <NSObject>

@optional

/// 商品图片／详情
- (void)didSelectGoodsIndexPath:(NSIndexPath *)indexPath;
/// 购物车按钮
- (void)didClickShopCartBtnIndexPath:(NSIndexPath *)indexPath;

@end

@interface OTShopCartRecommendTableViewCell : OTBaseTableViewCell

@property (nonatomic, weak) id<OTShopCartRecommendCellDelegate> delegate;

/**
 *  获取推荐cell的高度
 *
 *  @param count 数据源的数量
 *
 *  @return cell高度
 */
+ (CGFloat)getCellHeightWithDataSourceCount:(NSInteger)count;

/**
 *  设置推荐数据
 *
 *  @param dataSource 数据源
 */
- (void)setRecommendDataSource:(NSArray<OTGoodsModel *> *)dataSource;


@end
