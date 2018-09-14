//
//  OTWebViewModel.m
//  OneTreasure
//
//  Created by Frederic on 2016/11/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTWebViewModel.h"

@implementation OTWebViewModel

- (instancetype)initWithURLString:(NSString *)string title:(NSString *)titleString {
    if (self = [super init]) {
        _URLString = [string copy];
        _title = [titleString copy];
    }
    return self;
}

@end
