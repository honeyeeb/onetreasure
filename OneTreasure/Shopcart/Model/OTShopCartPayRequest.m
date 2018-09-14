//
//  OTShopCartPayRequest.m
//  OneTreasure
//
//  Created by Frederic on 2017/1/8.
//  Copyright © 2017年 honeyeeb. All rights reserved.
//

#import "OTShopCartPayRequest.h"

@implementation OTShopCartPayRequest

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"productID": @[@"productid", @"uuid"],
              @"price": @"price",
              @"qishu": @[@"qishu", @"shuji"],
              @"productNumber": @[@"productnum", @"cyrs"]};
}

@end
