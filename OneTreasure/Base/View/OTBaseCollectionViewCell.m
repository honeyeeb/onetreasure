//
//  OTBaseCollectionViewCell.m
//  OneTreasure
//
//  Created by Frederic on 2016/11/23.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTBaseCollectionViewCell.h"

@implementation OTBaseCollectionViewCell

+ (UINib *)getNib {
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
}

@end
