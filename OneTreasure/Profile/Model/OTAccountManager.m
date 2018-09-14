//
//  OTAccountManager.m
//  OneTreasure
//
//  Created by Frederic on 2016/12/13.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTAccountManager.h"
#import <UIKit/UIKit.h>

#import <SAMKeychain/SAMKeychain.h>
#import <YYModel/YYModel.h>
#import "OTNetworkManager.h"
#import "OTUserModel.h"
#import "OTCommon.h"
#import "HBKeyValueStore.h"
#import "OTStatistics.h"



NSString *const kOTAccountUserIDNotification                    = @"OTAccountUserIDNotification";


NSString *const kAccountDBName                                  = @"OTAccount.db";
NSString *const kAccountTableName                               = @"ot_account_table";

NSString *const kAccountDefaultID                               = @"10000";



@interface OTAccountManager ()

@property (nonatomic, strong) dispatch_queue_t accountQueue;

@property (nonatomic, strong) HBKeyValueStore *dbManager;

@end



@implementation OTAccountManager

+ (instancetype)sharedManger {
    static OTAccountManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [OTAccountManager new];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        // 串行
        _accountQueue = dispatch_queue_create("ot_account_queue", NULL);
        // 并行
//        _accountQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        /// 持久化
        _dbManager = [[HBKeyValueStore alloc] initDBWithName:kAccountDBName];
        if (![_dbManager isTableExists:kAccountTableName]) {
            [_dbManager createTableWithName:kAccountTableName];
        }
    }
    return self;
}

+ (NSString *)getUDIDString {
    NSString *bundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleIdentifierKey];
//    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    NSString *strApplicationUUID = [SAMKeychain passwordForService:bundleID account:bundleID];
    if (strApplicationUUID == nil) {
        strApplicationUUID  = [[[[UIDevice currentDevice] identifierForVendor] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [SAMKeychain setPassword:strApplicationUUID forService:bundleID account:bundleID];
    }
    return strApplicationUUID;
}

- (NSString *)userID {
    return self.userModel.userID;
}

- (OTUserModel *)userModel {
    id result = [self getUserInfoWithID:nil];
    OTUserModel *tmpModel;
    if (result && [result isKindOfClass:[NSDictionary class]]) {
        tmpModel = [OTUserModel yy_modelWithJSON:result];
    } else {
        tmpModel = nil;
    }
    return tmpModel;
}

- (void)accountSignInSuccess:(void (^)(void))success failed:(void (^)(void))failed {
    if (self.userID) {
        if (success) {
            success();
        }
    } else {
        if (failed) {
            failed();
        }
    }
}

#pragma mark - DB
/// 持久化账户信息
- (void)storeUserInfoWithDic:(id)userInfo accountID:(NSString *)accountID {
    if (userInfo) {
        WEAKSELF
        if (!accountID) {
            accountID = kAccountDefaultID;
        }
        dispatch_async(_accountQueue, ^{
            [weakSelf.dbManager putObject:userInfo withId:accountID intoTable:kAccountTableName];
        });
    }
}
/// 删除账户信息
- (void)deleteUserInfoWithID:(NSString *)accountID {
    if (!accountID) {
        accountID = kAccountDefaultID;
    }
    WEAKSELF
    dispatch_async(_accountQueue, ^{
        [weakSelf.dbManager deleteObjectById:accountID fromTable:kAccountTableName];
    });
    
    // 登出
    [OTStatistics profileSignOff];
}
/// 获取用户信息
- (id)getUserInfoWithID:(NSString *)accountID {
    if (!accountID) {
        accountID = kAccountDefaultID;
    }
    __block id reseult;
    dispatch_sync(_accountQueue, ^{
        reseult = [self.dbManager getObjectById:accountID fromTable:kAccountTableName];
    });
    return reseult;
}

#pragma mark - Network

- (void)POST:(NSString *)urlString params:(id)params completion:(AccountSuccessHandler)handler {
    if (params) {
        WEAKSELF
        NSURLSessionDataTask *task = [[OTNetworkManager sharedManager] POST:urlString params:params completion:^(NSDictionary *data, NSString *errMsg) {
            if (data) {
                NSDictionary *userJSON = data[@"user"];
                STRONGSELF
                if (userJSON) {
                    [strongSelf storeUserInfoWithDic:userJSON accountID:nil];
                    
                    if (handler) {
                        handler(YES, nil);
                    }
                } if (handler) {
                    handler(NO, errMsg);
                }
                
            } else {
                if (handler) {
                    handler(NO, errMsg);
                }
            }
        }];
        [task resume];
    } else {
        if (handler) {
            handler(NO, kErrorMessage);
        }
    }
}

- (void)signinWithParams:(id)params completion:(AccountSuccessHandler)handler {
    
    [self POST:[URL_HOST stringByAppendingString:URL_SIGNIN] params:params completion:handler];
}

- (void)signUpParams:(id)params completion:(AccountSuccessHandler)handler {
    
    [self POST:[URL_HOST stringByAppendingString:URL_SIGNUP] params:params completion:handler];
}

- (void)sendSMSParams:(id)params completion:(void (^)(NSString *smsID, NSString *errMsg))handler {
    if (params) {
        NSURLSessionDataTask *task = [[OTNetworkManager sharedManager] POST:[URL_HOST stringByAppendingString:URL_SMS_CODE] params:params completion:^(NSDictionary *data, NSString *errMsg) {
            NSString *smsID = [NSString stringWithFormat:@"%@", data[@"smsid"]];
            if (handler) {
                handler(smsID, errMsg);
            }
        }];
        [task resume];
    } else {
        if (handler) {
            handler(nil, kErrorMessage);
        }
    }
}

- (void)getUserInfoParams:(id)params completion:(AccountSuccessHandler)handler {
    
    [self POST:[URL_HOST stringByAppendingString:URL_ACCOUNT_INFO] params:params completion:handler];
}

- (void)POST:(NSString *)urlString params:(id)params codeCompletion:(AccountSuccessHandler)handler {
    
    if (params) {
        NSURLSessionDataTask *task = [[OTNetworkManager sharedManager] POST:urlString params:params completion:^(NSDictionary *data, NSString *errMsg) {
            if (data) {
                NSString *code = [NSString stringWithFormat:@"%@", data[@"code"]];
                NSString *msg = data[@"msg"];
                if (!msg) {
                    msg = kErrorMessage;
                }
                if (0 == [code integerValue]) {
                    if (handler) {
                        handler(YES, nil);
                    }
                } else {
                    if (handler) {
                        handler(NO, msg);
                    }
                }
                
            } else {
                if (handler) {
                    handler(nil, kErrorMessage);
                }
            }
        }];
        [task resume];
    } else {
        if (handler) {
            handler(nil, kErrorMessage);
        }
    }

}

- (void)resetPwdWithParams:(id)params completion:(AccountSuccessHandler)handler {
    
    [self POST:[URL_HOST stringByAppendingString:URL_RESET_PASSWORD] params:params codeCompletion:handler];
}

- (void)modifyPwdWithParams:(id)params completion:(AccountSuccessHandler)handler {
    
    if (params) {
        WEAKSELF
        NSURLSessionDataTask *task = [[OTNetworkManager sharedManager] POST:[URL_HOST stringByAppendingString:URL_MODIFY_PASSWORD] params:params completion:^(NSDictionary *data, NSString *errMsg) {
            if (data) {
                NSString *code = [NSString stringWithFormat:@"%@", data[@"code"]];
                if (0 == [code integerValue]) {
                    // 清除本地账户
                    [weakSelf deleteUserInfoWithID:nil];
                    
                    if (handler) {
                        handler(YES, nil);
                    }
                } else {
                    if (handler) {
                        handler(NO, kErrorMessage);
                    }
                }
                
            } else {
                if (handler) {
                    handler(nil, kErrorMessage);
                }
            }
        }];
        [task resume];
    } else {
        if (handler) {
            handler(nil, kErrorMessage);
        }
    }
}

- (void)modifyUserInfoParams:(id)params completion:(AccountSuccessHandler)handler {
    
    [self POST:[URL_HOST stringByAppendingString:URL_MODIFY_USER_INFO] params:params codeCompletion:handler];
}

- (void)rechargeParams:(id)params completion:(AccountSuccessHandler)handler {
    
    [self POST:[URL_HOST stringByAppendingString:URL_RECHARGE] params:params codeCompletion:handler];
}

- (void)uploadAvatarParams:(id)params avatarData:(NSData *)data completion:(AccountSuccessHandler)handler {
    
    [self POST:[URL_HOST stringByAppendingString:URL_UPLOAD_AVATAR] params:params codeCompletion:handler];
}

@end
