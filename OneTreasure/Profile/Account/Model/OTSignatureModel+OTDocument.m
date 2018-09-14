//
//  OTSignatureModel+OTDocument.m
//  OneTreasure
//
//  Created by Frederic on 2016/12/22.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTSignatureModel+OTDocument.h"

@implementation OTSignatureModel (OTDocument)

@dynamic userID, nickName, realName, postCode, provinceName, cityName, regionName, externalName, addressName;

- (void)setUserID:(NSString *)userID {
    if (userID) {
        self.paramsDic[kSignatureKeyUserID] = userID;
    }
}

- (void)setNickName:(NSString *)nickName {
    if (nickName) {
        self.paramsDic[kSignatureKeyNickName] = nickName;
    }
}

- (void)setRealName:(NSString *)realName {
    if (realName) {
        self.paramsDic[kSignatureKeyRealName] = realName;
    }
}

- (void)setAddressName:(NSString *)addressName {
    if (addressName) {
        self.paramsDic[kSignatureKeyAdds] = addressName;
    }
}

- (void)setPostCode:(NSString *)postCode {
    if (postCode) {
        self.paramsDic[kSignatureKeyPostCode] = postCode;
    }
}


@end
