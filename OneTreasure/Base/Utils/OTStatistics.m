//
//  OTStatistics.m
//  OneTreasure
//
//  Created by Frederic on 2017/1/13.
//  Copyright © 2017年 honeyeeb. All rights reserved.
//

#import "OTStatistics.h"
#import <UMMobClick/MobClick.h>
//#import <Firebase/Firebase.h>
#import "UMessage.h"

@implementation OTStatistics

/** 手动页面时长统计, 记录某个页面展示的时长.
 @param pageName 统计的页面名称.
 @param seconds 单位为秒，int型.
 */
+ (void)logPageView:(NSString *)pageName seconds:(int)seconds {
    [MobClick logPageView:pageName seconds:seconds];
}

/** 自动页面时长统计, 开始记录某个页面展示时长.
 使用方法：必须配对调用beginLogPageView:和endLogPageView:两个函数来完成自动统计，若只调用某一个函数不会生成有效数据。
 在该页面展示时调用beginLogPageView:，当退出该页面时调用endLogPageView:
 @param pageName 统计的页面名称.
 */
+ (void)beginLogPageView:(NSString *)pageName {
    [MobClick beginLogPageView:pageName];
    
//    [FIRAnalytics setScreenName:pageName screenClass:pageName];
}

/** 自动页面时长统计, 结束记录某个页面展示时长.
 使用方法：必须配对调用beginLogPageView:和endLogPageView:两个函数来完成自动统计，若只调用某一个函数不会生成有效数据。
 在该页面展示时调用beginLogPageView:，当退出该页面时调用endLogPageView:
 @param pageName 统计的页面名称.
 */
+ (void)endLogPageView:(NSString *)pageName {
    [MobClick beginLogPageView:pageName];
}

///---------------------------------------------------------------------------------------
/// @name  事件统计
///---------------------------------------------------------------------------------------
/** 结构化事件
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID。
 
 @param  keyPath 字符串数组代表的结构化事件路径，其长度最大为8，不能使用unicode 48以内的字符，keyPath[0]必须在网站注册事件ID.
 @param  value 事件的数值
 @param  label label 标签
 */
+ (void)event:(NSArray *)keyPath value:(int)value label:(NSString *)label {
    [MobClick event:keyPath value:value label:label];
}

/** 自定义事件,数量统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
 
 @param  eventId 网站上注册的事件Id.
 @para  label 分类标签。不同的标签会分别进行统计，方便同一事件的不同标签的对比,为nil或空字符串时后台会生成和eventId同名的标签.
 @para  accumulation 累加值。为减少网络交互，可以自行对某一事件ID的某一分类标签进行累加，再传入次数作为参数。
  //等同于 event:eventId label:eventId;
 */
+ (void)event:(NSString *)eventId {
    [MobClick event:eventId];
}
/** 自定义事件,数量统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
 // label为nil或@""时，等同于 event:eventId label:eventId;
 */
+ (void)event:(NSString *)eventId label:(NSString *)label {
    [MobClick event:eventId label:label];
}

/** 自定义事件,数量统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
 */
+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes {
    [MobClick event:eventId attributes:attributes];
    
//    [FIRAnalytics logEventWithName:eventId parameters:attributes];
}

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes counter:(int)number {
    [MobClick event:eventId attributes:attributes counter:number];
}

/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 beginEvent,endEvent要配对使用,也可以自己计时后通过durations参数传递进来
 
 @param  eventId 网站上注册的事件Id.
 @para  label 分类标签。不同的标签会分别进行统计，方便同一事件的不同标签的对比,为nil或空字符串时后台会生成和eventId同名的标签.
 @para  primarykey 这个参数用于和event_id一起标示一个唯一事件，并不会被统计；对于同一个事件在beginEvent和endEvent 中要传递相同的eventId 和 primarykey
 @para millisecond 自己计时需要的话需要传毫秒进来
 
 @warning 每个event的attributes不能超过10个
 eventId、attributes中key和value都不能使用空格和特殊字符，必须是NSString,且长度不能超过255个字符（否则将截取前255个字符）
 id， ts， du是保留字段，不能作为eventId及key的名称
 */
+ (void)beginEvent:(NSString *)eventId {
    [MobClick beginEvent:eventId];
}

/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

+ (void)endEvent:(NSString *)eventId {
    [MobClick endEvent:eventId];
}
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

+ (void)beginEvent:(NSString *)eventId label:(NSString *)label {
    [MobClick beginEvent:eventId label:label];
}
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

+ (void)endEvent:(NSString *)eventId label:(NSString *)label {
    [MobClick endEvent:eventId label:label];
}
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

+ (void)beginEvent:(NSString *)eventId primarykey:(NSString *)keyName attributes:(NSDictionary *)attributes {
    [MobClick beginEvent:eventId primarykey:keyName attributes:attributes];
}
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

+ (void)endEvent:(NSString *)eventId primarykey:(NSString *)keyName {
    [MobClick endEvent:eventId primarykey:keyName];
}
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

+ (void)event:(NSString *)eventId durations:(int)millisecond {
    [MobClick event:eventId durations:millisecond];
}
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

+ (void)event:(NSString *)eventId label:(NSString *)label durations:(int)millisecond {
    [MobClick event:eventId label:label durations:millisecond];
}
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */
+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes durations:(int)millisecond {
    [MobClick event:eventId attributes:attributes durations:millisecond];
}

#pragma mark - user methods
/** active user sign-in.
 使用sign-In函数后，如果结束该PUID的统计，需要调用sign-Off函数
 @param puid : user's ID
 @para provider : 不能以下划线"_"开头，使用大写字母和数字标识; 如果是上市公司，建议使用股票代码。
 */
+ (void)profileSignInWithPUID:(NSString *)puid {
    [MobClick profileSignInWithPUID:puid];
    
//    [FIRAnalytics setUserID:puid];
}
+ (void)profileSignInWithPUID:(NSString *)puid provider:(NSString *)provider {
    [MobClick profileSignInWithPUID:puid provider:provider];
    
//    [FIRAnalytics setUserID:nil];
}

/** active user sign-off.
 停止sign-in PUID的统计
 */
+ (void)profileSignOff {
    [MobClick profileSignOff];
}

///---------------------------------------------------------------------------------------
/// @name 地理位置设置
/// 需要链接 CoreLocation.framework 并且 #import <CoreLocation/CoreLocation.h>
///---------------------------------------------------------------------------------------

/** 设置经纬度信息
 @param latitude 纬度.
 @param longitude 经度.
 */
+ (void)setLatitude:(double)latitude longitude:(double)longitude {
    [MobClick setLatitude:latitude longitude:longitude];
}

/** 设置经纬度信息
 @param location CLLocation 经纬度信息
 */
//+ (void)setLocation:(CLLocation *)location;

///---------------------------------------------------------------------------------------
/// @name Utility函数
///---------------------------------------------------------------------------------------

/** 判断设备是否越狱，依据是否存在apt和Cydia.app
 */
+ (BOOL)isJailbroken {
    return [MobClick isJailbroken];
}

/** 判断App是否被破解
 */
+ (BOOL)isPirated {
    return [MobClick isPirated];
}

/** 绑定一个别名至设备（含账户，和平台类型）
 @warning 添加Alias的先决条件是已经成功获取到device_token，否则失败(kUMessageErrorDependsErr)
 @param name 账户，例如email
 @param type 平台类型，参见本文件头部的`kUMessageAliasType...`，例如：kUMessageAliasTypeSina
 @param handle block返回数据，error为获取失败时的信息，responseObject为成功返回的数据
 */
+ (void)addAlias:(NSString * __nonnull)name type:(NSString * __nonnull)type response:(nullable void (^)(id __nonnull responseObject,NSError *__nonnull error))handle {
    [UMessage addAlias:name type:type response:handle];
}

/** 绑定一个别名至设备（含账户，和平台类型）,并解绑这个别名曾今绑定过的设备。
 @warning 添加Alias的先决条件是已经成功获取到device_token，否则失败(kUMessageErrorDependsErr)
 @param name 账户，例如email
 @param type 平台类型，参见本文件头部的`kUMessageAliasType...`，例如：kUMessageAliasTypeSina
 @param handle block返回数据，error为获取失败时的信息，responseObject为成功返回的数据
 */
+ (void)setAlias:(NSString *__nonnull )name type:(NSString * __nonnull)type response:(nullable void (^)(id __nonnull responseObject,NSError *__nonnull error))handle {
    [UMessage setAlias:name type:type response:handle];
}

/** 删除一个设备的别名绑定
 @warning 删除Alias的先决条件是已经成功获取到device_token，否则失败(kUMessageErrorDependsErr)
 @param name 账户，例如email
 @param type 平台类型，参见本文件头部的`kUMessageAliasType...`，例如：kUMessageAliasTypeSina
 @param handle block返回数据，error为获取失败时的信息，responseObject为成功返回的数据
 */
+ (void)removeAlias:(NSString * __nonnull)name type:(NSString * __nonnull)type response:(nullable void (^)(id __nonnull responseObject, NSError *__nonnull error))handle {
    [UMessage removeAlias:name type:type response:handle];
}

@end
