//
//  OTUserModel.m
//  OneTreasure
//
//  Created by Frederic on 2016/12/16.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTUserModel.h"
#import <objc/runtime.h>


@implementation OTUserModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"userID": @"uid",
              @"nickName": @"nickname",
              @"realName": @"realname",
              @"credits": @"credits",
              @"avatorURLString": @"avatar",
              @"mobile": @"mobile",
              @"accessToken": @"accesstoken",
              @"addressName": @"addrdetail",
              @"postCode": @"postcode",
              @"gender": @"gender"};
}

+ (NSString *)getRandomIconNameEndString:(NSString *)end {
    NSString *iconNameStr = @"ot_random_animal_1";
    if (end) {
        iconNameStr = [iconNameStr stringByReplacingOccurrencesOfString:@"1" withString:end];
    } else {
        NSInteger random = arc4random() % 20;
        iconNameStr = [NSString stringWithFormat:@"ot_random_animal_%d", (int)random];
    }
    return iconNameStr;
}

- (NSString *)debugDescription {
    NSMutableString *str = [NSMutableString stringWithFormat:@"<%@:%p\n", NSStringFromClass([self class]), self];
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    for (int i = 0; i<count; i++) {
        // 取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        // 查看成员变量
        const char *name = ivar_getName(ivar);
        // 归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [str appendFormat:@"%s : %@\n", name, value];
    }
    free(ivars);
    [str appendString:@">"];
    return str;
}


#pragma mark - Coding

- (void)encodeWithCoder:(NSCoder *)encoder {
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    for (int i = 0; i<count; i++) {
        // 取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        // 查看成员变量
        const char *name = ivar_getName(ivar);
        // 归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [encoder encodeObject:value forKey:key];
    }
    free(ivars);
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i<count; i++) {
            // 取出i位置对应的成员变量
            Ivar ivar = ivars[i];
            // 查看成员变量
            const char *name = ivar_getName(ivar);
            // 归档
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [decoder decodeObjectForKey:key];
            // 设置到成员变量身上
            [self setValue:value forKey:key];
            
        }
        free(ivars);
    }
    return self;
}

@end
