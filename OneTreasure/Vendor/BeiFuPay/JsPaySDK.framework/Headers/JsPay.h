//
//  JsPay.h
//  JsPay
//
//  Created by 杰莘宏业 on 16/9/7.
//  Copyright © 2016年 杰莘宏业. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void(^CompletioBlock)(id resultDic);

typedef void(^otherPayBlock)(id applePay);

#define LXAlert(...) [[[UIAlertView alloc] initWithTitle:@"title" message:(__VA_ARGS__) delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show]
@interface JsPay : NSObject

+ (JsPay *)sharedInstance;


/**配置微信
 *  @param appId appid
 */
+(void)wechatpPayConfigWithApplication:(UIApplication *)application
         didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                                 appId:(NSString *)appId;
/*QQ支付
 */
- (void)QQWalletSDKHanldeApplication:(UIApplication*)application
                             openURL:(NSURL *)url
                   sourceApplication:(NSString *)sourceApplication
                          annotation:(id)annotation;

/**支付开关
 * @param currentcontroller 当前视图
 *  @param description  商品描述
 *  @param goodsAmount  商品价格，单位为分
 *  @param appId        appid
 *  @param paraId       商户Id
 *  @param childParaId  子商户Id
 *  @param orderId      订单Id
 *  @param scheme       调用授权的app注册在info.plist中的scheme
 *  @param attach       自定义参数
 *  @param key          密钥
 *  @param type         1-微信 2-支付宝 3-银联
 *  @param notifyUrl    异步回调接收地址
 *  @param resultDice   支付的回调(success成功，fail失败,微信和支付宝)
 *  @param otherPay     实现苹果支付
 */

- (void)startPayorderWithController:(UIViewController *)currentcontroller
                        description:(NSString *)description
                        goodsAmount:(NSString *)goodsAmount
                              appId:(NSString *)appId
                             paraId:(NSString *)paraId
                        childParaId:(NSString *)childParaId
                            orderId:(NSString *)orderId
                             scheme:(NSString *)scheme
                             attach:(NSString *)attach
                                key:(NSString *)key
                               type:(NSString *)type
                          notifyUrl:(NSString *)notifyUrl
                          backBlock:(CompletioBlock)resultDice
                           otherPay:(otherPayBlock)otherPay;


/**支付接口
 * @param currentcontroller 当前视图
 *  @param description  商品描述
 *  @param goodsAmount  商品价格，单位为分
 *  @param appId        appid
 *  @param paraId       商户Id
 *  @param childParaId  子商户Id
 *  @param orderId      订单Id
 *  @param scheme       调用授权的app注册在info.plist中的scheme
 *  @param attach       自定义参数
 *  @param key          密钥
 *  @param type         1-微信 2-支付宝 3-银联
 *  @param notifyUrl    异步回调接收地址
 *  @param resultDice   支付的回调(success成功，fail失败,微信和支付宝)
 */
- (void)payorderWithController:(UIViewController *)currentcontroller
                   description:(NSString *)description
                   goodsAmount:(NSString *)goodsAmount
                         appId:(NSString *)appId
                        paraId:(NSString *)paraId
                   childParaId:(NSString *)childParaId
                       orderId:(NSString *)orderId
                        scheme:(NSString *)scheme
                        attach:(NSString *)attach
                           key:(NSString *)key
                          type:(NSString *)type
                     notifyUrl:(NSString *)notifyUrl
                     backBlock:(CompletioBlock)resultDice;




@end
