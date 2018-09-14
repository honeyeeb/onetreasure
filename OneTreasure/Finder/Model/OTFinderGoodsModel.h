//
//  OTFinderGoodsModel.h
//  OneTreasure
//
//  Created by Frederic on 2016/11/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//
//  揭晓主页model

#import <Foundation/Foundation.h>

@interface OTFinderGoodsModel : NSObject
/// 商品标题
@property (nonatomic, copy) NSString *gtitle;

@property (nonatomic, copy) NSString *url;
/// 系统结束时间
@property (nonatomic, assign) NSInteger endtime;
/// 期数
@property (nonatomic, copy) NSString* periods;
/// 检查是否有参与人数
@property (nonatomic, assign) BOOL checkecy;
/// 到计时时间
@property (nonatomic, assign) NSTimeInterval jxtime;
/// 用户昵称
@property (nonatomic, copy) NSString *nickname;
/// 商品ID
@property (nonatomic, copy) NSString *itemid;
/// 图片路径
@property (nonatomic, copy) NSString *imgrul;
/// 揭晓类型：1已揭晓；2 正在揭晓中
@property (nonatomic, assign) NSInteger stauts;
/// 标题
@property (nonatomic, copy) NSString *tilte;
/// 用户ID
@property (nonatomic, copy) NSString *memberid;
/// 参与人次
@property (nonatomic, assign) NSInteger cynumber;
/// 用户头像
@property (nonatomic, copy) NSString *avatar;
/// 中奖ID
@property (nonatomic, copy) NSString *partakeid;
/// 幸运号
@property (nonatomic, copy) NSString *xyhao;
///  0: 普通商品，1: 苹果商品
@property (nonatomic, copy) NSString *typeid;

@end
