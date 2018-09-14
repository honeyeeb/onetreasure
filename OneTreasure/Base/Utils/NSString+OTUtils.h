//
//  NSString+OTUtils.h
//  OneTreasure
//
//  Created by Frederic on 2016/12/20.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSString (OTUtils)


#pragma mark - 基础字符串处理

/**
 *  字符串过滤，去掉两端的空格
 */
+ (NSString *)trimText:(NSString *)text;

/**
 去掉所有的空格

 */
+ (NSString *)trimEmptyText:(NSString *)text;

/**
 *  获取时间戳
 */
+ (NSString *)isoDateFromDate;

/**
 是否是空的字符串

 */
+ (BOOL)isEmptyString:(NSString *)string;

#pragma mark - JSON字符串格式化

/**
 *  把对象格式化为JSON字符串
 *
 *  @param object 需要格式化的对象
 *
 *  @return json 字符串
 */
+ (NSString *)jsonStringFormatFromObject:(id)object;

/**
 *  把jsonString 转化为 json对象
 *
 *  @param string json字符串
 *
 *  @return ID
 */
+ (id)jsonObjectFormatFromJsonString:(NSString *)string;

#pragma mark - 数字辅助计算方法

/**
 *  数字大小的辅助计算方法 9999以下显示正常数字 大于9999显示X万
 *
 *  @return ID
 */
- (NSString *)countCalculate;

/**
 *  计算字符串长度 中文2字节 英文1字节 系统表情4字节
 *
 *  @return 半角字符字节数
 */
- (NSUInteger)calculateDBC_CaseLength;

#pragma mark - 平台类型转换方法、性别类型转换方法

/**
 *  性别格式化
 *
 *  @return ID
 */
- (NSString *)genderFormat;

#pragma mark - 正则表达式

/**
 *  当前字符串是否是标准的手机号 13x、15x、17x、18x 共11位
 *
 *  @return 是否是有效的手机号
 */
- (BOOL)isValidTelPhoneNumber;

/**
 *  判断输入的密码是否符合密码规则
 *
 *  @return 是否符合密码规则
 */
- (BOOL)isValidPassword;

/**
 *  判断输入的邀请码是否符合邀请码规则
 *
 *  @return 是否符合邀请码规则
 */
- (BOOL)isValidInvitationCode ;

/// MD5 Hash
- (NSString *)ot_MD5String;

@end
