//
//  OTUserModel.h
//  OneTreasure
//
//  Created by Frederic on 2016/12/16.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//
// 用户信息


#import <Foundation/Foundation.h>

/// 性别
typedef NS_ENUM(NSInteger, OTUserGender) {
    OTUserGenderUnknow          = 0,
    OTUserGenderMale,
    OTUserGenderFemale,
    OTUserGenderSecret,
    
};

/// 用户信息
@interface OTUserModel : NSObject<NSCoding>

/// 用户ID
@property (nonatomic, copy) NSString *userID;
/// 昵称
@property (nonatomic, copy) NSString *nickName;
/// 真名
@property (nonatomic, copy) NSString *realName;
/// 余额
@property (nonatomic, copy) NSString *credits;
/// 头像URL
@property (nonatomic, copy) NSString *avatorURLString;
/// 手机号
@property (nonatomic, copy) NSString *mobile;
/// Token
@property (nonatomic, copy) NSString *accessToken;
/// 地址
@property (nonatomic, copy) NSString *addressName;
/// 邮编
@property (nonatomic, copy) NSString *postCode;

@property (nonatomic, assign) OTUserGender gender;


+ (NSString *)getRandomIconNameEndString:(NSString *)end;

@end
