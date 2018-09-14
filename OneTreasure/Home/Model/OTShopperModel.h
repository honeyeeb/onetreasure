//
//  OTShopperModel.h
//  OneTreasure
//
//  Created by Frederic on 2017/1/16.
//  Copyright © 2017年 honeyeeb. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 商品参与人
@interface OTShopperModel : NSObject
/// 头像URL地址
@property (nonatomic, copy) NSString *imgString;
/// IP
@property (nonatomic, copy) NSString *ipString;
/// 创建时间
@property (nonatomic, copy) NSString *createTime;
/// 期数
@property (nonatomic, copy) NSString *shuqi;
/// 参与者ID
@property (nonatomic, copy) NSString *memberID;
/// 商品ID
@property (nonatomic, copy) NSString *goodsID;
/// 昵称
@property (nonatomic, copy) NSString *nickName;
/// 购买数量
@property (nonatomic, copy) NSString *shopNumber;
/// 参与记录ID
@property (nonatomic, copy) NSString *uuid;



@end
