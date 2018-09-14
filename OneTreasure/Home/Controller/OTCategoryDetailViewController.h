//
//  OTCategoryDetailViewController.h
//  OneTreasure
//
//  Created by Frederic on 2016/12/1.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//
//  分页跳转详细

#import "OTBaseTableViewController.h"


/// 页面来源
typedef NS_ENUM(NSInteger, OTCategoryDetailFromType) {
    /// 分类列表
    OTCategoryDetailFromTypeCategoryList,
    /// 首页广告条
    OTCategoryDetailFromTypeBanner,
};

@class OTCategorySelectModel;

@interface OTCategoryDetailViewController : OTBaseTableViewController
/// 分页的ID，名称
@property (nonatomic, copy) OTCategorySelectModel *cateModel;
/// 页面来源
@property (nonatomic, assign) OTCategoryDetailFromType fromType;

@end
