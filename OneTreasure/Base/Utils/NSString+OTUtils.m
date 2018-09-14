//
//  NSString+OTUtils.m
//  OneTreasure
//
//  Created by Frederic on 2016/12/20.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "NSString+OTUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>


@implementation NSString (OTUtils)

#pragma mark - 基础字符串处理

+ (NSString *)trimText:(NSString *)text {
    if ([text isKindOfClass:[NSString class]]) {
        if (text == nil || [@"" isEqualToString:text]||[@"<null>" isEqualToString:text] || [@"(null)" isEqualToString:text] || [text isEqual:[NSNull null]]) {
            return @"";
        }
        return  [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return @"";
}

+ (NSString *)trimEmptyText:(NSString *)text {
    if ([text isKindOfClass:[NSString class]]) {
        if (text == nil || [@"" isEqualToString:text]||[@"<null>" isEqualToString:text] || [@"(null)" isEqualToString:text] || [text isEqual:[NSNull null]]) {
            return @"";
        }
        return  [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return @"";
}

//获得时间戳
+ (NSString *)isoDateFromDate {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int date = (long long int)time;
    NSString *timeStr = [NSString stringWithFormat:@"%lli",date];
    return timeStr;
}

+ (BOOL)isEmptyString:(NSString *)string {
    if (string == nil || string.length == 0 || [string rangeOfString:@" "].location != NSNotFound) {
        return YES;
    }
    return NO;
}


#pragma mark - JSON字符串格式化

/**
 *  把对象格式化为JSON字符串
 *
 *  @param object 需要格式化的对象
 *
 *  @return json 字符串
 */
+ (NSString *)jsonStringFormatFromObject:(id)object
{
    //把参数转化为JSON 串
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:NULL];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    return jsonString ;
}

+ (id)jsonObjectFormatFromJsonString:(NSString *)string {
    
    if (TRIM_TEXT(string).length <= 0) {
        return nil;
    }
    
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingMutableContainers
                                                      error:&error];
    if(error){
        return nil;
    }
    
    return jsonObject;
}


#pragma mark - 数字辅助计算方法

- (NSString *)countCalculate {
    
    if(TRIM_TEXT(self).length <= 0){
        return @"0";
    }
    
    NSInteger count = [self integerValue];
    
    count = count > 0 ? count : 0;
    
    if(count > 9999){
        
        return [NSString stringWithFormat:@"%@万",@(count/10000)];
    }else if(count > 999){
        
        return [NSString stringWithFormat:@"%@千",@(count/1000)];
    }else{
        
        return [NSString stringWithFormat:@"%@",@(count)];
    }
}

/**
 *  计算字符串长度 中文2字节 英文1字节 系统表情4字节
 *
 *  @return 半角字符字节数
 */
- (NSUInteger)calculateDBC_CaseLength {
    
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [self dataUsingEncoding:encoding];
    return [data length];
}

#pragma mark - 平台类型转换方法

- (NSString *)genderFormat {
    
    if ([@"1" isEqualToString:self]) {  //男
        
        return @"1";
    }else if([@"2" isEqualToString:self]) { // 2 女
        
        return @"0";
    }else { //未知
        
        return @"3";
    }
}

#pragma mark - 正则表达式

/**
 *  当前字符串是否是标准的手机号 13x、15x、16x、17x、18x 共11位
 *
 *  @return 是否是有效的手机号
 */
- (BOOL)isValidTelPhoneNumber {
    
    NSString *pattern = @"(kp)?1[2|3|4|5|6|7|8|9|][0-9]{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

/**
 *  判断输入的密码是否符合密码规则
 *
 *  @return 是否符合密码规则
 */
- (BOOL)isValidPassword {
    if ([@"" isEqualToString:self]) {
        return NO ;
    }
    else if(self.length < 6 || self.length > 20){
        
        return NO ;
    }
    return YES ;
}

/**
 *  判断输入的邀请码是否符合邀请码规则
 *
 *  @return 是否符合邀请码规则
 */
- (BOOL)isValidInvitationCode {
    NSString *pattern = @"[A-Za-z0-9]{6}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

- (NSString *)ot_MD5String {
    CC_MD5_CTX md5;
    CC_MD5_Init (&md5);
    CC_MD5_Update (&md5, [self UTF8String], (CC_LONG) [self length]);
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final (digest, &md5);
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0],  digest[1],
                   digest[2],  digest[3],
                   digest[4],  digest[5],
                   digest[6],  digest[7],
                   digest[8],  digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    
    return s;
}

@end
