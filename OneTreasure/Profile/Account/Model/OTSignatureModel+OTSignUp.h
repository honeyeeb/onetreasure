//
//  OTSignatureModel+OTSignUp.h
//  OneTreasure
//
//  Created by Frederic on 2016/12/22.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTSignatureModel.h"

/// 注册/重置密码
@interface OTSignatureModel (OTSignUp)

/// 用户密码
@property (nonatomic, copy) NSString *userPassword;
/// 短信ID
@property (nonatomic, copy) NSString *smsID;
/// 短信验证码
@property (nonatomic, copy) NSString *smsCode;


@end
