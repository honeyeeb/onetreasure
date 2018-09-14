//
//  OTShopCartPayRequest.h
//  OneTreasure
//
//  Created by Frederic on 2017/1/8.
//  Copyright © 2017年 honeyeeb. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 购物车发送
@interface OTShopCartPayRequest : NSObject
/// 商品ID
@property (nonatomic, copy) NSString *productID;
/// 期数
@property (nonatomic, copy) NSString *qishu;
/// 价格
@property (nonatomic, copy) NSString *price;
/// 产品数量
@property (nonatomic, copy) NSString *productNumber;



@end
