//
//  OTAccountManager.h
//  OneTreasure
//
//  Created by Frederic on 2016/12/13.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//
//  账户管理


#import <Foundation/Foundation.h>

@class OTUserModel;

typedef void (^AccountSuccessHandler)(BOOL success, NSString *errMsg);

/// 用户登录成功
extern NSString *const kOTAccountUserIDNotification;


@interface OTAccountManager : NSObject


/// 用户的ID
@property (nonatomic, assign, readonly) NSString* userID;
/// 用户信息
@property (nonatomic, strong, readonly) OTUserModel *userModel;


+ (instancetype)sharedManger;
/// 设备的UDID
+ (NSString *)getUDIDString;


/**
 本地是否有用户登录

 @param success 成功登录后调用此方法
 @param failed 没有登录后调用此方法
 */
- (void)accountSignInSuccess:(void (^)(void))success failed:(void (^)(void))failed;


/// 删除账户
- (void)deleteUserInfoWithID:(NSString *)accountID;

#pragma mark - Network
/**
 用户登录

 @param params 登录所需要的参数
 @param handler 结果回调
 */
- (void)signinWithParams:(id)params completion:(AccountSuccessHandler)handler;

/**
 用户注册账号

 @param params 注册所需要的参数
 @param handler 结果回调
 */
- (void)signUpParams:(id)params completion:(AccountSuccessHandler)handler;

/**
 发送短信验证码

 @param params 参数
 @param handler 结果回调(验证码ID)
 */
- (void)sendSMSParams:(id)params completion:(void (^)(NSString *smsID, NSString *errMsg))handler;

/**
 获取用户的基本信息

 @param params 参数
 @param handler 结果回调
 */
- (void)getUserInfoParams:(id)params completion:(AccountSuccessHandler)handler;

/**
 重置密码

 @param params 重置密码参数
 @param handler 结果回调
 */
- (void)resetPwdWithParams:(id)params completion:(AccountSuccessHandler)handler;

/**
 修改米啊米

 @param params 修改密码参数
 @param handler 结果回调
 */
- (void)modifyPwdWithParams:(id)params completion:(AccountSuccessHandler)handler;

/**
 修改用户信息

 */
- (void)modifyUserInfoParams:(id)params completion:(AccountSuccessHandler)handler;

/**
 充值

 @param params 充值的参数
 @param handler 结果回调
 */
- (void)rechargeParams:(id)params completion:(AccountSuccessHandler)handler;

/**
 上传头像

 @param params 头像参数
 @param data   头像数据
 @param handler 结果回调
 */
- (void)uploadAvatarParams:(id)params avatarData:(NSData *)data completion:(AccountSuccessHandler)handler;

@end
