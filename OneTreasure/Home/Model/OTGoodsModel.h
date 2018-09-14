//
//  OTGoodsModel.h
//  OneTreasure
//
//  Created by Frederic on 2016/11/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//
//  首页商品model

#import <Foundation/Foundation.h>

@interface OTGoodsModel : NSObject<NSCopying, NSCopying>
/// 期数
@property (nonatomic, copy) NSString *shuji;
/// 价格
@property (nonatomic, copy) NSString *price;
/// 状态 1上架，0下架
@property (nonatomic, assign) NSInteger status;
/// 总需求
@property (nonatomic, assign) NSInteger gtotail;
/// 参与人数
@property (nonatomic, assign) NSInteger cyrs;
/// 商品ID
@property (nonatomic, copy) NSString *uuid;
/// 专区 0、 普通专区； 1、十元专区
@property (nonatomic, assign) NSInteger zhuanqu;
/// 图片地址
@property (nonatomic, copy) NSString *imgurl;
/// 标题
@property (nonatomic, copy) NSString *tilte;
///  0: 普通商品，1: 苹果商品
@property (nonatomic, copy) NSString *typeid;

- (NSDictionary *)statisticsJSON;

@end
