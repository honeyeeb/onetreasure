//
//  OTSignatureModel+OTRecharge.h
//  OneTreasure
//
//  Created by Frederic on 2017/1/7.
//  Copyright © 2017年 honeyeeb. All rights reserved.
//

#import "OTSignatureModel.h"


extern NSString *const kSignatureRechargeAmount;
extern NSString *const kSIgnatureRechargeOrderNumber;


/// 充值
@interface OTSignatureModel (OTRecharge)

/// 用户ID
@property (nonatomic, copy) NSString *userID;
/// 充值金额
@property (nonatomic, copy) NSString *amount;
/// 订单号 (uid)_unix时间戳
@property (nonatomic, copy) NSString *orderNumber;

@end
