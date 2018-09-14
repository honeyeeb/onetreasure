//
//  OTSignatureModel+OTUploadAvatar.h
//  OneTreasure
//
//  Created by Frederic on 2017/1/16.
//  Copyright © 2017年 honeyeeb. All rights reserved.
//

#import "OTSignatureModel.h"

/// 上传头像
@interface OTSignatureModel (OTUploadAvatar)

/// 头像
@property (nonatomic, strong) NSData *avatarData;
/// 用户ID
@property (nonatomic, copy) NSString *userID;

@end
