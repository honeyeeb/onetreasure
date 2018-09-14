//
//  OTPayManager.h
//  OneTreasure
//
//  Created by Frederic on 2017/1/7.
//  Copyright © 2017年 honeyeeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// 选择支付方式
typedef NS_ENUM(NSInteger, OTPayType) {
    OTPayTypeWeChat = 1,
    OTPayTypeAliPay = 2,
    OTPayTypeUninPay = 3,
    /// 苹果应用内支付
    OTPayTypeIAP = 4,
};


/// 支付接口
@interface OTPayManager : NSObject

+ (instancetype)sharedInstance;

/// 设置微信
+ (void)setupJSPayApplication:(UIApplication *)application launthOptions:(NSDictionary *)launthOptions;


/**
 调用支付接口

 @param controller  当前视图
 @param description 商品描述
 @param goodsAmount 数量
 @param orderId 订单ID(uid_unixtime)
 @param attach 自定义参数(uid)
 @param type 类型
 @param handler 回调
 */
+ (void)jsPayWithController:(UIViewController *)controller
                description:(NSString *)description
                goodsAmount:(NSString *)goodsAmount
                    orderId:(NSString *)orderId
                     attach:(NSString *)attach
                       type:(OTPayType)type
                 completion:(void (^)(id result))handler;


@end
