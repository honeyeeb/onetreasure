//
//  OTSignatureModel+OTShopCartPay.m
//  OneTreasure
//
//  Created by Frederic on 2017/1/8.
//  Copyright © 2017年 honeyeeb. All rights reserved.
//

#import "OTSignatureModel+OTShopCartPay.h"

NSString *const kShopCartPayRequestInfo                 = @"cartArray";




@implementation OTSignatureModel (OTShopCartPay)

@dynamic cartArray, userID;


- (void)setCartArray:(NSString *)cartArray {
    if (cartArray) {
        self.paramsDic[kShopCartPayRequestInfo] = cartArray;
    }
}

- (void)setUserID:(NSString *)userID {
    if (userID) {
        self.paramsDic[kSignatureKeyUserID] = userID;
    }
}


@end
