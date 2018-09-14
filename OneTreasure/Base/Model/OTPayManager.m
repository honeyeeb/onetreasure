//
//  OTPayManager.m
//  OneTreasure
//
//  Created by Frederic on 2017/1/7.
//  Copyright © 2017年 honeyeeb. All rights reserved.
//

#import "OTPayManager.h"
#import <JsPaySDK/JsPay.h>


NSString *const kJSHelloKey                 = @"HK86C66bNFFNGWMR773cGR9a9PQ52D5D";

NSString *const kJSAppID                    = @"10252";

NSString *const kJSParaID                   = @"10433";

NSString *const kJSWeChatID                 = @"wx7ef1d413ceefb537";

NSString *const URL_PAY_NOTIFY              = @"http://one.josmob.com:8334/one/order/jshypay.do";


@interface OTPayManager ()



@end


@implementation OTPayManager

+ (instancetype)sharedInstance {
    static OTPayManager *staticPay = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticPay = [OTPayManager new];
    });
    return staticPay;
}

+ (void)setupJSPayApplication:(UIApplication *)application launthOptions:(NSDictionary *)launthOptions {
    dispatch_async(dispatch_get_main_queue(), ^{
        [JsPay wechatpPayConfigWithApplication:application didFinishLaunchingWithOptions:launthOptions appId:kJSAppID];
    });
}

+ (void)jsPayWithController:(UIViewController *)controller description:(NSString *)description goodsAmount:(NSString *)goodsAmount orderId:(NSString *)orderId attach:(NSString *)attach type:(OTPayType)type completion:(void (^)(id))handler {
    NSString *desc = [description stringByAppendingString:@"元"];
    NSString *schems;
    NSString *types = [NSString stringWithFormat:@"%d", (int)type];
    switch (type) {
        case OTPayTypeWeChat:
            schems = kJSWeChatID;
            
            break;
        case OTPayTypeAliPay:
            schems = @"qyalipay";
            
            break;
        case OTPayTypeUninPay:
            schems = @"uninpay";
            
            break;
        case OTPayTypeIAP:
            
            break;
    }
    [[JsPay sharedInstance] payorderWithController:controller description:desc goodsAmount:goodsAmount appId:kJSAppID paraId:kJSParaID childParaId:@"QY" orderId:orderId scheme:schems attach:attach key:kJSHelloKey type:types notifyUrl:URL_PAY_NOTIFY backBlock:handler];
    
}

@end
