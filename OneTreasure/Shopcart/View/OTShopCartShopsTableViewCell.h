//
//  OTShopCartShopsTableViewCell.h
//  OneTreasure
//
//  Created by Frederic on 2016/12/2.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//
//  清单／购物车页面的待付款商品cell

#import "OTBaseTableViewCell.h"

@class OTGoodsModel;

typedef NS_ENUM(NSUInteger, SHGoodsButtonType) {
    SHGoodsButtonTypeImage,
    SHGoodsButtonTypeLabel,
};
@interface SHGoodsButton : UIButton

@property (nonatomic, assign) SHGoodsButtonType goodsType;

@end

typedef NS_ENUM(NSInteger, OTShopCartNormalCellActionType) {
    OTShopCartNormalCellActionTypeSelect    = 0,
    OTShopCartNormalCellActionTypeDetail,
    OTShopCartNormalCellActionTypeSubtract,
    OTShopCartNormalCellActionTypeAdd,
    
};

@protocol OTShopCartShopCellDelegate <NSObject>

@optional
/**
 *  有效商品页面按钮点击事件
 *
 *  @param model 当前cell 的model
 *  @param type  事件类型
 */
- (void)normalCellActionWithModel:(OTGoodsModel *)model
                             type:(OTShopCartNormalCellActionType)type
                        indexPath:(NSIndexPath *)indexPath;

@end

@interface OTShopCartShopsTableViewCell : OTBaseTableViewCell


@property (nonatomic, weak) id<OTShopCartShopCellDelegate> delegate;

@property (weak, nonatomic) OTGoodsModel *goodsModel;

@property (weak, nonatomic) IBOutlet UIImageView *lineView;

@property (weak, nonatomic) NSIndexPath *indexPath;

- (void)setSelectedBtnSelected:(BOOL)select;

@end
