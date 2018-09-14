//
//  OTSignatureModel+OTDocument.h
//  OneTreasure
//
//  Created by Frederic on 2016/12/22.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTSignatureModel.h"

/// 获取资料／修改资料
@interface OTSignatureModel (OTDocument)

/// 用户ID
@property (nonatomic, copy) NSString *userID;
/// 昵称
@property (nonatomic, copy) NSString *nickName;
/// 姓名
@property (nonatomic, copy) NSString *realName;
/// 省
@property (nonatomic, copy) NSString *provinceName;
/// 市
@property (nonatomic, copy) NSString *cityName;
/// 区
@property (nonatomic, copy) NSString *regionName;
/// 街道
@property (nonatomic, copy) NSString *externalName;
/// 全部地址
@property (nonatomic, copy) NSString *addressName;
/// 邮编
@property (nonatomic, copy) NSString *postCode;

@end
