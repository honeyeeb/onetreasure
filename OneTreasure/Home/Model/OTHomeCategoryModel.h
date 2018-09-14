//
//  OTHomeCategoryModel.h
//  OneTreasure
//
//  Created by Frederic on 2016/11/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//
//  首页的分类选择model

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OTGoodsSortType) {
    /// 人气
    OTGoodsSortTypePopulay          = 1,
    /// 进度
    OTGoodsSortTypeProgress,
    /// 最新
    OTGoodsSortTypeLast,
    /// 总需求
    OTGoodsSortTypeTotalNeeds,
    /// 十元
    OTGoodsSortTypeTenYuan,
    /// 一元
    OTGoodsSortTypeOneYuan,
    /// 一元最新
    OTGoodsSortTypeOneYuanLast,
};

@interface OTHomeCategoryModel : NSObject

@property (nonatomic, copy) NSString *categoryTitle;

@property (nonatomic, assign) OTGoodsSortType  sortType;

+ (NSArray *)getDefaultCategorys;

+ (NSString *)getGoodsSortName:(OTGoodsSortType)type;

@end
