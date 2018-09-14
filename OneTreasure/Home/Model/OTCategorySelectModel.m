//
//  OTCategorySelectModel.m
//  OneTreasure
//
//  Created by Frederic on 2016/12/1.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTCategorySelectModel.h"

@implementation OTCategorySelectModel

- (id)copyWithZone:(NSZone *)zone {
    OTCategorySelectModel *model = [[[self class] allocWithZone:zone] init];
    model.cateid = self.cateid;
    model.url = self.url;
    model.catename = self.catename;
    model.iconurl = self.iconurl;
    return model;
}

@end
