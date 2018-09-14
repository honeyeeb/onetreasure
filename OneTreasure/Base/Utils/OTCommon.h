//
//  OTCommon.h
//  OneTreasure
//
//  Created by Frederic on 2016/11/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTCommon : NSObject


#pragma mark - URL
extern NSString *const URL_HOST;
/// 首页banner
extern NSString *const URL_HOME_BANNER;
/// 首页通知
extern NSString *const URL_HOME_NOTICE;
/// 首页商品
extern NSString *const URL_HOME_GOODS;
/// 最先揭晓
extern NSString *const URL_FINDER_GOODS;
/// 商品详情
extern NSString *const URL_GOODS_DETAIL;
/// 分类
extern NSString *const URL_ATEGOTY_SELECT;
/// 倒计时结束
extern NSString *const URL_COUNT_DOWN_FINISH;
/// 为你推荐／猜你喜欢
extern NSString *const URL_RECOMMEND_GOODS;
/// 关于我们
extern NSString *const URL_ABOUT_ME;
/// 常见问题
extern NSString *const URL_NORMAL_QA;
/// 登录
extern NSString *const URL_SIGNIN;
/// 注册
extern NSString *const URL_SIGNUP;
/// 发送手机验证码
extern NSString *const URL_SMS_CODE;
/// 获取个人信息
extern NSString *const URL_ACCOUNT_INFO;
/// 重置密码
extern NSString *const URL_RESET_PASSWORD;
/// 修改密码
extern NSString *const URL_MODIFY_PASSWORD;
/// 修改用户信息
extern NSString *const URL_MODIFY_USER_INFO;
/// 充值记录
extern NSString *const URL_CHARGE_HISTORY;
/// 夺宝记录
extern NSString *const URL_SHOP_HISTORY;
/// 中奖纪录
extern NSString *const URL_LUCK_HISTORY;
/// 充值
extern NSString *const URL_RECHARGE;
/// 购物车金币支付
extern NSString *const URL_COIN_PAY;
/// 上传头像
extern NSString *const URL_UPLOAD_AVATAR;
/// 商品详情的图片
extern NSString *const URL_GOODS_DETAIL_IMGS;
/// 商品详情的往期揭晓
extern NSString *const URL_GOODS_LUCK_HISTORY;
/// 晒单分享
extern NSString *const URL_GOODS_SHAR;
/// 支付开关
extern NSString *const URL_ENABLE_IAP;
/// 判断直接购买的开关
extern NSString *const URL_DIRICT_PURCHACE;


/// 购物车变化通知
extern NSString *const kOTShopCartCountPriceNotification;
/// 购物车通知对象key
extern NSString *const kOTShopCartNotifiCountValue;




@end
