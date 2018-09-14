//
//  OTShopperModel.m
//  OneTreasure
//
//  Created by Frederic on 2017/1/16.
//  Copyright © 2017年 honeyeeb. All rights reserved.
//

#import "OTShopperModel.h"

@implementation OTShopperModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"imgString": @"avatar",
              @"ipString": @"ip",
              @"createTime": @"createtime",
              @"shopNumber": @"cynumber",
              @"shuqi": @"shuqi",
              @"memberID": @"memberid",
              @"goodsID": @"goodsid",
              @"nickName": @"nickname",
              @"uuid": @"uuid"};
}

@end
