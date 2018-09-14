//
//  OTHomeCategoryModel.m
//  OneTreasure
//
//  Created by Frederic on 2016/11/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTHomeCategoryModel.h"

@implementation OTHomeCategoryModel

- (instancetype)initWithTitle:(NSString *)title sortType:(OTGoodsSortType)type {
    if (self = [super init]) {
        self.categoryTitle = title;
        self.sortType = type;
    }
    return self;
}

+ (NSArray *)getDefaultCategorys {
    NSMutableArray *categorys;
    OTHomeCategoryModel *m1 = [[OTHomeCategoryModel alloc] initWithTitle:@"人气" sortType:OTGoodsSortTypePopulay];
//    OTHomeCategoryModel *m2 = [[OTHomeCategoryModel alloc] initWithTitle:@"进度" sortType:OTGoodsSortTypeProgress];
//    OTHomeCategoryModel *m3 = [[OTHomeCategoryModel alloc] initWithTitle:@"最新" sortType:OTGoodsSortTypeLast];
//    OTHomeCategoryModel *m4 = [[OTHomeCategoryModel alloc] initWithTitle:@"总需人数" sortType:OTGoodsSortTypeTotalNeeds];
    OTHomeCategoryModel *m5 = [[OTHomeCategoryModel alloc] initWithTitle:@"十元专区" sortType:OTGoodsSortTypeTenYuan];
    OTHomeCategoryModel *m6 = [[OTHomeCategoryModel alloc] initWithTitle:@"一元专区" sortType:OTGoodsSortTypeOneYuan];
    OTHomeCategoryModel *m7 = [[OTHomeCategoryModel alloc] initWithTitle:@"一元最新" sortType:OTGoodsSortTypeOneYuanLast];
    categorys = [NSMutableArray arrayWithObjects:m1, m5, m6, m7, nil];
    return [categorys copy];
}

+ (NSString *)getGoodsSortName:(OTGoodsSortType)type {
    NSString *name;
    switch ((NSInteger)type) {
        case OTGoodsSortTypePopulay:
            name = @"rq";
            break;
        case OTGoodsSortTypeProgress:
            name = @"jd";
            break;
        case OTGoodsSortTypeLast:
            name = @"new";
            break;
        case OTGoodsSortTypeTotalNeeds:
            name = @"zxrs";
            break;
        case OTGoodsSortTypeTenYuan:
            name = @"zq";
            break;
        case OTGoodsSortTypeOneYuan:
            name = @"yiyzq";
            break;
        case OTGoodsSortTypeOneYuanLast:
            name = @"yqnew";
            break;
        
    }
    return name;
}

@end
