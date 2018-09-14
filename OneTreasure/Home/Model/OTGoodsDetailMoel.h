//
//  OTGoodsDetailMoel.h
//  OneTreasure
//
//  Created by Frederic on 2016/11/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 商品活动状态
typedef NS_ENUM(NSInteger, OTGoodsRuleStatus) {
    /// 已经揭晓
    OTGoodsRuleStatusDone       = 1,
    /// 正在揭晓
    OTGoodsRuleStatusSuccess,
    /// 进行中
    OTGoodsRuleStatusDoing,
};

/// 缩略图
@interface OTThumbImgModel : NSObject

@property (nonatomic, copy) NSString *imgwidth;

@property (nonatomic, copy) NSString *imgheight;

@property (nonatomic, copy) NSString *imgurl;

@end


/// 商品详情
@interface OTGoodsDetailMoel : NSObject

@property (nonatomic, strong) NSDate *endtime;
/// 期数
@property (nonatomic, copy) NSString *periods;
/// 商品主图地址
@property (nonatomic, copy) NSString *gmianimgurl;
/// 获奖者ID
@property (nonatomic, copy) NSString *memberid;
/// 商品详情缩略图
@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, assign) OTGoodsRuleStatus status;
/// 商品详情缩略图
@property (nonatomic, strong) NSArray<OTThumbImgModel *> *imgurdata;
/// 获奖者参与人数
@property (nonatomic, assign) NSInteger cynumber;
/// 到计时时间
@property (nonatomic, strong) NSDate *kjtime;
/// 商品标题
@property (nonatomic, copy) NSString *prodname;
/// 参与人数
@property (nonatomic, assign) NSInteger cyrs;
/// 获奖者头像
@property (nonatomic, copy) NSString *avatar;
/// 获奖者参与记录ID
@property (nonatomic, copy) NSString *partakeid;
/// 获奖者IP
@property (nonatomic, copy) NSString *ip;
/// 进行中期数
@property (nonatomic, assign) NSInteger subperiods;
/// 开始时间
@property (nonatomic, copy) NSString *createtime;
/// 商品总需求
@property (nonatomic, assign) NSInteger zxq;
/// Status为1时
/// Partakeid <=0
/// 检查是否有参与用户 1、true  2、false
/// true: 由于福彩中心通讯故障，暂时无法获取老时时彩开奖结果正在等待老时时彩开奖结果。
/// false: 很抱歉,本期众筹失败
@property (nonatomic, assign) NSInteger checkecy;
/// 商品单价
@property (nonatomic, copy) NSString *price;
/// 检查是否有会员参与 (1、true  2、false)
@property (nonatomic, assign) BOOL iscyflas;
/// 商品详情图片，数组，分割
@property (nonatomic, strong) NSString *imgdetailurl;
/// 获奖结束时间
@property (nonatomic, strong) NSDate *jxtime;
/// 专区 0、 普通专区； 1、十元专区
@property (nonatomic, assign) NSInteger zhuanqu;
/// 获奖者幸运号
@property (nonatomic, copy) NSString *xyhao;
/// 用户参与人次
@property (nonatomic, assign) NSInteger usercynum;
/// 用户参与全部幸运号
@property (nonatomic, strong) NSArray *groupxyhao;
/// 下一期跳转地址
@property (nonatomic, copy) NSString *url;

@end
