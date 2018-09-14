//
//  OTWebViewModel.h
//  OneTreasure
//
//  Created by Frederic on 2016/11/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//
//  网页的model

#import <Foundation/Foundation.h>

@interface OTWebViewModel : NSObject

@property (nonatomic, copy) NSString *URLString;

@property (nonatomic, copy) NSString *title;

- (instancetype)initWithURLString:(NSString *)string title:(NSString *)titleString;

@end
