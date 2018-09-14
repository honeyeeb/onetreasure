//
//  OTSignatureModel.m
//  OneTreasure
//
//  Created by Frederic on 2016/12/21.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

/**
 签名算法:
 根据参数名称将除sign外的所有参与签名请求参数按照字母先后顺序排序:key + value .... key + value
 对要求签名的请求参数按key做的升序排列, value拼接|。
 例如：将foo=1,bar=2,baz=3 排序为bar=2,baz=3,foo=1
 参数值链接后，得到拼装字符串2|3|1
 系统使用MD5加密方式
 将secret同时拼接到参数字符串头、尾部进行md5加密后，再转化成大写，格式是：byte2hex (md5(secretkey1|key2|key3...secret))。
 */


#import "OTSignatureModel.h"

#import "NSString+OTUtils.h"
#import "OTAccountManager.h"


NSString *const kSignatureKeyIMei                               = @"imei";
NSString *const kSignatureKeyTimestamp                          = @"timestamp";
NSString *const kSignatureKeyVersion                            = @"version";
NSString *const kSignatureKeyChannel                            = @"channel";
NSString *const kSignatureKeyMobile                             = @"mobile";
NSString *const kSignatureKeyPassword                           = @"userpwd";
NSString *const kSignatureKeyType                               = @"type";
NSString *const kSignatureKeySign                               = @"sign";
NSString *const kSignatureKeySMS                                = @"valcode";
NSString *const kSignatureKeySMSID                              = @"smsid";
NSString *const kSignatureKeyUserID                             = @"uid";
NSString *const kSignatureKeyNickName                           = @"nickname";
NSString *const kSignatureKeyRealName                           = @"realname";
NSString *const kSignatureKeyAdds                               = @"addrdetail";
NSString *const kSignatureKeyPostCode                           = @"postcode";

NSString *const kSignatureKeyModifyOldPassword                  = @"password";
NSString *const kSignatureKeyNewPassword                        = @"newpassword";



NSString *const kSignUpSuccessNotification                      = @"kSignUpSuccessNotification";

NSString *const kHelloWorld                                     = @"U1d7ac67de698a6f67b8effa72da3c13";

NSString *const kVersion                                        = @"v1";

@interface OTSignatureModel ()

/// IMEI，唯一标识
@property (nonatomic, copy, readwrite) NSString *imei;
/// 时间戳(s)
@property (nonatomic, assign, readwrite) NSInteger timestamp;
/// token
@property (nonatomic, copy) NSString *helloWorld;

/// 签名的参数
@property (nonatomic, strong) NSMutableDictionary *signatureDic;

@end

@implementation OTSignatureModel

- (instancetype)init {
    if (self = [super init]) {
        _paramsDic = [NSMutableDictionary dictionary];
        _signatureDic = [NSMutableDictionary dictionary];
        _helloWorld = kHelloWorld;
        _imei = [[OTAccountManager getUDIDString] copy];
        if (_imei) {
            _signatureDic[kSignatureKeyIMei] = _imei;
            _paramsDic[kSignatureKeyIMei] = _imei;
        }
        _timestamp = (NSInteger)([[NSDate date] timeIntervalSince1970] * 1000);
        _signatureDic[kSignatureKeyTimestamp] = @(_timestamp);
        _paramsDic[kSignatureKeyTimestamp] = @(_timestamp);
        
        _version = kVersion;
        _paramsDic[kSignatureKeyVersion] = _version;
        
        _channel = OT_CHANNEL;
        _paramsDic[kSignatureKeyChannel] = _channel;
    }
    return self;
}

- (void)setVersion:(NSString *)version {
    _version = version;
    if (_version) {
        _paramsDic[kSignatureKeyVersion] = _version;
    }
}

- (void)setChannel:(NSString *)channel {
    _channel = channel;
    if (_channel) {
        _paramsDic[kSignatureKeyChannel] = _channel;
    }
}

- (void)setMobile:(NSString *)mobile {
    _mobile = mobile;
    if (mobile) {
        _paramsDic[kSignatureKeyMobile] = mobile;
    }
}

- (void)setHelloWorld:(NSString *)hello {
    if (hello) {
        _helloWorld = hello;
    }
}

- (NSString *)signatureString {
    NSMutableString *tmpSignature = [NSMutableString string];
    NSArray *signKeyArray = [[_signatureDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
        return [obj1 compare:obj2 options:NSLiteralSearch];
    }];
    if (signKeyArray.count > 0) {
        __block NSMutableArray *tmpArr = [NSMutableArray array];
        [signKeyArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *key = [[NSString alloc] initWithFormat:@"%@", obj];
            id value = _signatureDic[key];
            if (value) {
                [tmpArr addObject:value];
            }
        }];
        NSString *valus = [tmpArr componentsJoinedByString:@"|"];
        NSString *md5String = [[_helloWorld stringByAppendingFormat:@"|%@|%@", valus, _helloWorld] ot_MD5String];
        tmpSignature = [[md5String uppercaseString] mutableCopy];
    }

    return tmpSignature;
}

- (NSString *)seriaParamString {
    NSString *resultParams = @"";
    NSArray *allKeys = [_paramsDic allKeys];
    NSArray *paramKey = [allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
        return [obj1 compare:obj2 options:NSLiteralSearch];
    }];
    if (paramKey.count > 0) {
        __block NSMutableArray *tmpParamArr = [NSMutableArray array];
        [paramKey enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *key = [[NSString alloc] initWithFormat:@"%@", obj];
            id value = _paramsDic[key];
            NSString *tmp = [[NSString alloc] initWithFormat:@"%@=%@", key, value];
            if (tmp) {
                [tmpParamArr addObject:tmp];
            }
        }];
        if (tmpParamArr.count > 0) {
            NSString *params = [tmpParamArr componentsJoinedByString:@"&"];
            resultParams = [NSString stringWithFormat:@"%@=%@&%@", kSignatureKeySign, [self signatureString], params];
        }
    }
    
    return resultParams;
}

@end
