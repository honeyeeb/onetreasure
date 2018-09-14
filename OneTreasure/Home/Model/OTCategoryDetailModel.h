//
//  OTCategoryDetailModel.h
//  OneTreasure
//
//  Created by Frederic on 2016/12/1.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//
//  分类详情

#import <Foundation/Foundation.h>

@interface OTCategoryDetailModel : NSObject

@property (nonatomic, copy) NSString *shuji;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *uuid;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) NSInteger gtotail;

@property (nonatomic, assign) NSInteger cyrs;

@property (nonatomic, assign) NSInteger zhuanqu;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *tilte;

@property (nonatomic, copy) NSString *imgurl;

@end
