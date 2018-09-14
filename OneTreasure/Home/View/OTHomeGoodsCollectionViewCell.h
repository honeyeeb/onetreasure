//
//  OTHomeGoodsCollectionViewCell.h
//  OneTreasure
//
//  Created by Frederic on 2016/11/23.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTBaseCollectionViewCell.h"

@class OTProgressView;
@class OTGoodsModel;

@protocol OTHomeGoodsCollectionCellDelegate <NSObject>

@optional
- (void)didClickShopCartBtnIndexPath:(NSIndexPath *)indexPath;

@end

@interface OTHomeGoodsCollectionViewCell : OTBaseCollectionViewCell

@property (nonatomic, weak) id<OTHomeGoodsCollectionCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImgView;

@property (weak, nonatomic) IBOutlet UIImageView *goodsTagImgView;

@property (weak, nonatomic) IBOutlet UILabel *goodsNameLab;

@property (weak, nonatomic) IBOutlet UIButton *addShopcartBtn;

@property (weak, nonatomic) IBOutlet OTProgressView *progressView;

@property (weak, nonatomic) IBOutlet UILabel *totalNumLab;

@property (weak, nonatomic) IBOutlet UILabel *percentLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsImgWidthConstraint;


- (void)setGoodsModel:(OTGoodsModel *)goodsModel indexPath:(NSIndexPath *)index;

@end
