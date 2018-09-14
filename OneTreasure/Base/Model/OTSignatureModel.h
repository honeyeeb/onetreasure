//
//  OTSignatureModel.h
//  OneTreasure
//
//  Created by Frederic on 2016/12/21.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//
//  账户系统请求参数的model


#import <Foundation/Foundation.h>

extern NSString *const kSignatureKeyIMei;
extern NSString *const kSignatureKeyTimestamp;
extern NSString *const kSignatureKeyVersion;
extern NSString *const kSignatureKeyChannel;
extern NSString *const kSignatureKeyMobile;
extern NSString *const kSignatureKeyPassword;
extern NSString *const kSignatureKeyType;
extern NSString *const kSignatureKeySMS;
extern NSString *const kSignatureKeySMSID;

extern NSString *const kSignatureKeyUserID;
extern NSString *const kSignatureKeyNickName;
extern NSString *const kSignatureKeyRealName;
extern NSString *const kSignatureKeyAdds;
extern NSString *const kSignatureKeyPostCode;

extern NSString *const kSignatureKeyModifyOldPassword;
extern NSString *const kSignatureKeyNewPassword;


/// 注册成功，手机号+密码
extern NSString *const kSignUpSuccessNotification;


@interface OTSignatureModel : NSObject

/// 所有参数
@property (nonatomic, strong) NSMutableDictionary *paramsDic;

/// IMEI，唯一标识
@property (nonatomic, copy, readonly) NSString *imei;
/// 时间戳(s)
@property (nonatomic, assign, readonly) NSInteger timestamp;
/// 版本
@property (nonatomic, copy) NSString *version;
/// 渠道
@property (nonatomic, copy) NSString *channel;
/// 手机号码
@property (nonatomic, copy) NSString *mobile;


/// 设置签名token
- (void)setHelloWorld:(NSString *)hello;
/// 签名后结果
- (NSString *)signatureString;
/// 序列化后的参数
- (NSString *)seriaParamString;

@end
