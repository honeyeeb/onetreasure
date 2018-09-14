//
//  OTSignatureModel+OTRecharge.m
//  OneTreasure
//
//  Created by Frederic on 2017/1/7.
//  Copyright © 2017年 honeyeeb. All rights reserved.
//

#import "OTSignatureModel+OTRecharge.h"


NSString *const kSignatureRechargeAmount                = @"amount";
NSString *const kSIgnatureRechargeOrderNumber           = @"orderno";

@implementation OTSignatureModel (OTRecharge)
@dynamic amount, orderNumber, userID;

- (void)setUserID:(NSString *)userID {
    if (userID) {
        self.paramsDic[kSignatureKeyUserID] = userID;
    }
}

- (void)setAmount:(NSString *)amount {
    if (amount) {
        self.paramsDic[kSignatureRechargeAmount] = amount;
    }
}

- (void)setOrderNumber:(NSString *)orderNumber {
    if (orderNumber) {
        self.paramsDic[kSIgnatureRechargeOrderNumber] = orderNumber;
    }
}

@end
