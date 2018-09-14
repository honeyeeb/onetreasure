//
//  OTSignatureModel+OTUploadAvatar.m
//  OneTreasure
//
//  Created by Frederic on 2017/1/16.
//  Copyright © 2017年 honeyeeb. All rights reserved.
//

#import "OTSignatureModel+OTUploadAvatar.h"

@implementation OTSignatureModel (OTUploadAvatar)

@dynamic avatarData, userID;

- (void)setAvatarData:(NSData *)avatarData {
    if (avatarData) {
        self.paramsDic[@"img"] = avatarData;
    }
}

- (void)setUserID:(NSString *)userID {
    if (userID) {
        self.paramsDic[kSignatureKeyUserID] = userID;
    }
}

@end
