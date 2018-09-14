//
//  OTHomeGoodsCollectionViewCell.m
//  OneTreasure
//
//  Created by Frederic on 2016/11/23.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTHomeGoodsCollectionViewCell.h"

#import "OTProgressView.h"
#import "UIView+OTRedious.h"
#import "OTGoodsModel.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface OTHomeGoodsCollectionViewCell ()

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation OTHomeGoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_addShopcartBtn addRoundedCorners:UIRectCornerAllCorners withRadii:CGSizeMake(12, 12)];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_progressView setNeedsLayout];
    [_progressView layoutIfNeeded];
    [_progressView addRoundedCorners:UIRectCornerAllCorners withRadii:CGSizeMake(2.0, 2.0)];
    _progressView.progressViewStyle = UIProgressViewStyleBar;
    _progressView.backgroundColor = [UIColor clearColor];
    _progressView.trackTintColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
    _progressView.progressTintColor = [UIColor colorWithRed:0.94 green:0.45 blue:0.29 alpha:1.00];
    
    // 重新计算图片的宽度
    _goodsImgWidthConstraint.constant = self.frame.size.width * 9 / 16;
}

- (void)updateConstraints {
    [super updateConstraints];
    
}

- (void)setGoodsModel:(OTGoodsModel *)goodsModel indexPath:(NSIndexPath *)index {
    _indexPath = index;
    if (goodsModel) {
        _goodsNameLab.text = goodsModel.tilte;
        [_goodsImgView sd_setImageWithURL:[NSURL URLWithString:goodsModel.imgurl] placeholderImage:[UIImage imageNamed:@"good_default"]];
        float progress = goodsModel.cyrs / (goodsModel.gtotail * 1.00 );
        _progressView.progress = progress;
        _percentLab.text = [NSString stringWithFormat:@"%.f%%", progress * 100];
        _totalNumLab.text = [NSString stringWithFormat:@"总需  %ld", (long)goodsModel.gtotail];
    }
}

- (IBAction)shopCartBtnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickShopCartBtnIndexPath:)]) {
        [self.delegate didClickShopCartBtnIndexPath:self.indexPath];
    }
}


@end
