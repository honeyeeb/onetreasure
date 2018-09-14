//
//  OTGoodsModel.m
//  OneTreasure
//
//  Created by Frederic on 2016/11/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTGoodsModel.h"
#import <objc/runtime.h>


@implementation OTGoodsModel

#pragma mark - Coping

- (id)copyWithZone:(NSZone *)zone {
    OTGoodsModel *copyModel = [[self class] allocWithZone:zone];
    if (copyModel) {
        copyModel.shuji = [_shuji copy];
        copyModel.price = [_price copy];
        copyModel.status = _status;
        copyModel.gtotail = _gtotail;
        copyModel.cyrs = _cyrs;
        copyModel.uuid = [_uuid copy];
        copyModel.zhuanqu = _zhuanqu;
        copyModel.imgurl = [_imgurl copy];
        copyModel.tilte = [_tilte copy];
    }
    return copyModel;
}

- (NSDictionary *)statisticsJSON {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (_shuji) {
        dic[@"shuji"] = _shuji;
    }
    if (_tilte) {
        dic[@"title"] = _tilte;
    }
    if (_price) {
        dic[@"price"] = _price;
    }
    dic[@"canyu"] = [NSString stringWithFormat:@"%@", @(_cyrs)];
    
    return dic;
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
