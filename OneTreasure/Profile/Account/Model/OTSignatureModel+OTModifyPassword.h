//
//  OTSignatureModel+OTModifyPassword.h
//  OneTreasure
//
//  Created by Frederic on 2016/12/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTSignatureModel.h"

/// 修改密码
@interface OTSignatureModel (OTModifyPassword)

/// 用户ID
@property (nonatomic, copy) NSString *userID;
/// 旧密码
@property (nonatomic, copy) NSString *originPassword;
/// 新密码
@property (nonatomic, copy) NSString *newPassword;



@end
