//
//  OTCommon.m
//  OneTreasure
//
//  Created by Frederic on 2016/11/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTCommon.h"

@implementation OTCommon
/// host
NSString *const URL_HOST                                        = @"https://qyweb.josmob.com:8336";
/// 首页的广告
NSString *const URL_HOME_BANNER                                 = @"/banner.htm";
/// 首页的通知
NSString *const URL_HOME_NOTICE                                 = @"/index.htm?method=jszjjl";
/// 首页的商品列表
NSString *const URL_HOME_GOODS                                  = @"/index.htm";
/// 最新揭晓
NSString *const URL_FINDER_GOODS                                = @"/jxindex.htm";
/// 商品详情
NSString *const URL_GOODS_DETAIL                                = @"/item.htm";
/// 分类
NSString *const URL_ATEGOTY_SELECT                              = @"/category.htm";

NSString *const URL_COUNT_DOWN_FINISH                           = @"/jxindex.htm";

NSString *const URL_RECOMMEND_GOODS                             = @"/recommend.htm";

NSString *const URL_ABOUT_ME                                    = @"/about.htm";

NSString *const URL_NORMAL_QA                                   = @"/new/pb/cjwt.htm";

NSString *const URL_SIGNIN                                      = @"/one/user/login.json";

NSString *const URL_SIGNUP                                      = @"/one/user/register.json";

NSString *const URL_SMS_CODE                                    = @"/one/getValCode.json";

NSString *const URL_ACCOUNT_INFO                                = @"/one/user/getProfile.json";

NSString *const URL_RESET_PASSWORD                              = @"/one/user/resetpwd.json";

NSString *const URL_MODIFY_PASSWORD                             = @"/one/user/changepwd.json";

NSString *const URL_MODIFY_USER_INFO                            = @"/one/user/modifyProfile.json";

NSString *const URL_CHARGE_HISTORY                              = @"/czjl.htm";
/// 夺宝记录
NSString *const URL_SHOP_HISTORY                                = @"/dbjl.htm";
/// 中奖纪录
NSString *const URL_LUCK_HISTORY                                = @"/zjjl.htm";
/// 充值
NSString *const URL_RECHARGE                                    = @"/one/user/reCharge.json";

NSString *const URL_COIN_PAY                                    = @"/one/user/buy.json";

NSString *const URL_UPLOAD_AVATAR                               = @"/one/user/uploadAvatar.json";

NSString *const URL_GOODS_DETAIL_IMGS                           = @"/itemintro.htm";

NSString *const URL_GOODS_LUCK_HISTORY                          = @"/history.htm";

NSString *const URL_GOODS_SHAR                                  = @"/share.htm";

NSString *const URL_ENABLE_IAP                                  = @"/new/pay.htm";

NSString *const URL_DIRICT_PURCHACE                             = @"https://raw.githubusercontent.com/honeyeeb/onetresure/master/README.md";




#pragma mark

NSString *const kOTShopCartCountPriceNotification               = @"kOTShopCartCountPriceNotification";
NSString *const kOTShopCartNotifiCountValue                     = @"kOTShopCartNotificationCountValue";




@end
