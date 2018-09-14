//
//  OTNetworkManager.h
//  OneTreasure
//
//  Created by Frederic on 2016/11/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//
// 网络统一请求管理


#import <Foundation/Foundation.h>

/// 网络结果回调
typedef void (^NetWorkHandler)(NSDictionary *data, NSString *errMsg);

@interface OTNetworkManager : NSObject

+ (instancetype)sharedManager;

/// GET
- (NSURLSessionDataTask *)GET:(NSString *)urlString params:(id)params completion:(NetWorkHandler)handler;

/// POST
- (NSURLSessionDataTask *)POST:(NSString *)urlString params:(id)params completion:(NetWorkHandler)handler;



///**
// *  GET请求
// *
// *  @param URLString  url地址
// *  @param parameters 请求参数
// *  @param handler    请求成功的回调
// *
// *  @return 当前任务的task
// */
//- (NSURLSessionDataTask *)GET:(NSString *)URLString
//                   parameters:(id)parameters
//                   completion:(NetWorkHandler)handler;
//
///**
// *  POST请求
// *
// *  @param URLString  url地址
// *  @param parameters 请求参数
// *  @param handler    成功的回调
// *
// *  @return 当前任务的task
// */
//- (NSURLSessionDataTask *)POST:(NSString *)URLString
//                    parameters:(id)parameters
//                    completion:(NetWorkHandler)handler;


@end
