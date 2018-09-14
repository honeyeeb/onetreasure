//
//  OTCategorySelectModel.h
//  OneTreasure
//
//  Created by Frederic on 2016/12/1.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//
//  分类选择model

#import <Foundation/Foundation.h>

@interface OTCategorySelectModel : NSObject<NSCopying>

/// 分类名称
@property (nonatomic, copy) NSString *cateid;
/// 分类名称
@property (nonatomic, copy) NSString *iconurl;
/// 分类名称
@property (nonatomic, copy) NSString *url;
/// 分类名称
@property (nonatomic, copy) NSString *catename;


@end
