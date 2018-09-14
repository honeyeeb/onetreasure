//
//  OTHomeBannerMode.h
//  OneTreasure
//
//  Created by Frederic on 2016/11/24.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//
//  首页广告

#import <Foundation/Foundation.h>


@interface OTHomeBannerMode : NSObject

@property (nonatomic, assign) NSInteger order;

@property (nonatomic, strong) NSDate *createdate;

@property (nonatomic, copy) NSString *uuid;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *gourl;

@property (nonatomic, copy) NSString *imgurl;

@property (nonatomic, copy) NSString *tilte;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *clienturl;

@end
