//
//  OTSignatureModel+OTModifyPassword.m
//  OneTreasure
//
//  Created by Frederic on 2016/12/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTSignatureModel+OTModifyPassword.h"

@implementation OTSignatureModel (OTModifyPassword)

@dynamic userID, originPassword, newPassword;

- (void)setUserID:(NSString *)userID {
    if (userID) {
        self.paramsDic[kSignatureKeyUserID] = userID;
    }
}

- (void)setOriginPassword:(NSString *)originPassword {
    if (originPassword) {
        self.paramsDic[kSignatureKeyModifyOldPassword] = originPassword;
    }
}

- (void)setNewPassword:(NSString *)newPassword {
    if (newPassword) {
        self.paramsDic[kSignatureKeyNewPassword] = newPassword;
    }
}

@end
