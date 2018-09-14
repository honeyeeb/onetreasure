//
//  OTSignatureModel+OTSignUp.m
//  OneTreasure
//
//  Created by Frederic on 2016/12/22.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTSignatureModel+OTSignUp.h"

@implementation OTSignatureModel (OTSignUp)

@dynamic userPassword, smsID, smsCode;

- (void)setUserPassword:(NSString *)userPassword {
    if (userPassword) {
        self.paramsDic[kSignatureKeyPassword] = userPassword;
    }
}

- (void)setSmsID:(NSString *)smsID {
    if (smsID) {
        self.paramsDic[kSignatureKeySMSID] = smsID;
    }
}

- (void)setSmsCode:(NSString *)smsCode {
    if (smsCode) {
        self.paramsDic[kSignatureKeySMS] = smsCode;
    }
}

@end
