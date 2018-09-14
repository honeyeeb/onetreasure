//
//  OTGoodsDetailShopperTableViewCell.h
//  OneTreasure
//
//  Created by Frederic on 2017/1/16.
//  Copyright © 2017年 honeyeeb. All rights reserved.
//

#import "OTBaseTableViewCell.h"
#import "OTShopperModel.h"

/// 商品详情参与用户者
@interface OTGoodsDetailShopperTableViewCell : OTBaseTableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;

@property (weak, nonatomic) OTShopperModel *shopperModel;

@end
