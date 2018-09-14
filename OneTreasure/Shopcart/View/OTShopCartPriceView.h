//
//  OTShopCartPriceView.h
//  OneTreasure
//
//  Created by Frederic on 2016/12/10.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//
// 购物车／清单页面底部的价格，结算


#import <UIKit/UIKit.h>

@protocol OTShopCartPriceViewDelegate <NSObject>

@optional
/// 去结算按钮
- (void)shopCartSubmitOrderBtnAction;
/// 选择全部按钮
- (void)shopCartSelectedAllBtnAction;


@end

@interface OTShopCartPriceView : UIView

/// 页面事件回调
@property (nonatomic, weak) id<OTShopCartPriceViewDelegate> delegate;


//- (void)setBlurBackground;

/**
 *  设置是否选中 全选
 *
 *  @param select 是否
 */
- (void)setSelectAll:(BOOL)select;
/**
 *  根据价格设置当前价格显示
 *
 *  @param price 价格
 */
- (void)setTotalPriceTextWithPrice:(NSString*)price;
/**
 *  设置额外信息显示
 *
 *  @param text 额外信息
 */
- (void)setDetailText:(NSString*)text;
/**
 *  设置去支付个数
 *
 *  @param count 数量
 */
- (void)setPayButtonText:(NSInteger)count;

+ (NSMutableAttributedString*)setAtttrbleStr:(NSString *)str withFontRMB:(CGFloat)rmbFond bigFond:(CGFloat)bigFond smallFond:(CGFloat)smallFond;


@end
