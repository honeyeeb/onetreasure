//
//  OTGoodsDetailViewController.h
//  OneTreasure
//
//  Created by Frederic on 2016/11/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//
//  商品详情页

#import "OTBaseTableViewController.h"

@interface OTGoodsDetailParam : NSObject
/// 商品ID
@property (nonatomic, copy) NSString *goodsID;
/// 商品期数
@property (nonatomic, copy) NSString *periods;
/// 初始化
- (instancetype)initWithGoodsID:(NSString *)goodsID period:(NSString *)period;

@end

/// 商品详情页
@interface OTGoodsDetailViewController : OTBaseTableViewController
/// 获取商品详情的参数
@property (nonatomic, strong) OTGoodsDetailParam *goodsParam;

@end
