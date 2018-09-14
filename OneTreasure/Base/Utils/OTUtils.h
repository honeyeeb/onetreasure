//
//  OTUtils.h
//  OneTreasure
//
//  Created by Frederic on 2016/11/23.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#ifndef OTUtils_h
#define OTUtils_h

/***************************************************************************************************
 *  App 版本以及固件信息
 */

/**
 *  版本version信息
 */
#define app_version           [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

/**
 *  版本build信息
 */
#define app_build             [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

/**
 *  应用名称
 */
#define OT_APP_NAME           [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]

/**
 *  APP版本
 */
#define kAPPVersion           [NSString stringWithFormat:@"%@",app_version]

/**
 *  系统版本 e.g. @"7.0"
 */
#define kSystemVersion        [[UIDevice currentDevice] systemVersion]

/**
 *  设备类型 e.g. @"iPhone", @"iPod touch"
 */
#define kDeviceModel          [[UIDevice currentDevice] model]

/**
 *  设备名称 e.g. "My iPhone"
 */
#define kDeviceName           [[UIDevice currentDevice] name]

/**
 *  设备安装的系统名称 e.g. @"iOS"
 */
#define kDeviceSystemName     [[UIDevice currentDevice] systemName]

/**
 *  设备的点和像素的缩放比例
 */
#define kDeviceScale          [UIScreen mainScreen].scale

/**
 *  根据iphone6设计稿计算相对高度
 */
#define kScaleHeight(height)  (SCREEN_HEIGHT * (height)/667.0)
#define kScaleWidth(width)    (SCREEN_WIDTH * (width)/375.0)
/********************************************************************************************
 *  App Frame
 */

/**
 *  屏幕宽度
 */
#define  SCREEN_WIDTH                 [UIScreen mainScreen].bounds.size.width
/**
 *  屏幕高度
 */
#define  SCREEN_HEIGHT                [UIScreen mainScreen].bounds.size.height

#define ScreenMaxLength     (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define ScreenMinLength     (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && ScreenMaxLength < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && ScreenMaxLength == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && ScreenMaxLength >= 667.0)
#define IS_IPHONE_6P (IS_IPHONE && ScreenMaxLength == 736.0)

// 距左边边距
#define  kLeftRightPadding                 12.0

#define RGB_COLOR(r, g, b, a)           [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:(a)]

#define StringHasString(fatherString,sonString) ([fatherString rangeOfString:sonString].location !=NSNotFound)

#ifndef WEAKSELF
#define WEAKSELF __weak __typeof(self) weakSelf = self;
#endif

#define STRONGSELF __strong __typeof(self) strongSelf = weakSelf;

#define kErrorMessage                        @"诶呀，太火爆了，请您稍后重试"

#define OT_CHANNEL                           @"Sofia"

#define OT_DEEVICE_TOKEN                     @"ot_device_token"

/// 是否支持直接购买
#define OT_ENABLE_DIRECT_PURCHAGE               @"OTEnableDirectPurchase"
/// 是否需要过滤苹果的产品
#define OT_FILTER_APPLES                        @"OTShouldFilterApples"

#define OT_ENABLE_NETWORK                       @"OTEnableNetwork"

#ifdef DEBUG
#define OTLog(format, ...) do {                                                                          \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0)
#else
#   define OTLog(...)
#endif

#define TRIM_TEXT(__X__) [NSString trimText:__X__]

/*****************************************************************************************************
 *  版本比较的宏
 */

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#endif /* OTUtils_h */
