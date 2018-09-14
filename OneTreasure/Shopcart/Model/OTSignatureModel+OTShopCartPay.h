//
//  OTSignatureModel+OTShopCartPay.h
//  OneTreasure
//
//  Created by Frederic on 2017/1/8.
//  Copyright © 2017年 honeyeeb. All rights reserved.
//

#import "OTSignatureModel.h"

@interface OTSignatureModel (OTShopCartPay)

/// 选中的购物车商品信息JSON
@property (nonatomic, copy) NSString *cartArray;
/// 用户ID
@property (nonatomic, copy) NSString *userID;


@end
