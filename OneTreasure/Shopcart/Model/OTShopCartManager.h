//
//  OTShopCartManager.h
//  OneTreasure
//
//  Created by Frederic on 2016/12/8.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//
//  购物车数据、接口管理


#import <Foundation/Foundation.h>

@class OTGoodsModel;


@interface OTShopCartManager : NSObject

/// 购物车中的数据
@property (nonatomic, strong, readonly) NSArray* shopCartArray;
/// 购物车的商品总数量
@property (nonatomic, copy, readonly) NSString* totalCount;
/// 选中商品的价格
@property (nonatomic, copy, readonly) NSString* selectedPrice;
/// 选中的商品ID
@property (nonatomic, strong, readonly) NSArray* selectedIDArray;



/// 单例
+ (instancetype)sharedInstance;

/// 向购物车中添加商品,每次添加一个商品单位
- (void)addGoods:(OTGoodsModel *)goodsModel;

/// 减少购物车中的商品，每次减少一个商品单位
- (void)subtractGoods:(OTGoodsModel *)goodsModel;
/// 减少购物车中商品
- (void)subtractGoodsWithIndex:(NSInteger)index;
/// 删除某一种商品
- (void)removeGoods:(OTGoodsModel *)goodsModel;
/// 删除某一商品
- (void)removeGoodsWithIndex:(NSInteger)index;
/// 删除所有商品
- (void)removeAllGoods;

/**
 选中／取消选中
 @param goodsModel 商品
 */
- (void)selectOrDeselectGoods:(OTGoodsModel *)goodsModel;
/// 选中／取消选中
- (void)selectOrDeselectGoodsWithIndex:(NSInteger)index;
/// 选中／取消选中所有
- (void)setPaySelectedAll:(BOOL)paySelectedAll;
/// 是否选中所有
- (BOOL)paySelectedAll;

/// 余额支付选中的商品
- (void)payResuestCompletion:(void (^)(NSInteger code, NSString *errMsg))handler;
/// 直接购买
- (void)directPayWithPatams:(NSString *)param completion:(void (^)(NSInteger code, NSString *errMsg))handler;


@end
