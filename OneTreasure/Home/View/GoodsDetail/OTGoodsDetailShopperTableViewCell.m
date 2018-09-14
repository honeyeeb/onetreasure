//
//  OTGoodsDetailShopperTableViewCell.m
//  OneTreasure
//
//  Created by Frederic on 2017/1/16.
//  Copyright © 2017年 honeyeeb. All rights reserved.
//

#import "OTGoodsDetailShopperTableViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>




@implementation OTGoodsDetailShopperTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _iconImg.layer.cornerRadius = _iconImg.frame.size.height / 2.0;
    _iconImg.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setShopperModel:(OTShopperModel *)shopperModel {
    _shopperModel = shopperModel;
    
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:shopperModel.imgString] placeholderImage:[UIImage imageNamed:@"good_default"]];
    
    NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:shopperModel.nickName attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.94 green:0.46 blue:0.29 alpha:1.00] }];
    [titleAtt appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%@)", shopperModel.ipString]]];
    
    _titleLab.attributedText = titleAtt;
    
    NSString *detailAtt = [NSString stringWithFormat:@"参与了%@人次", shopperModel.shopNumber];
    detailAtt = [detailAtt stringByAppendingString:shopperModel.createTime];
    
    _detailLab.text = detailAtt;
}

@end
