//
//  OTShopCartShopsTableViewCell.m
//  OneTreasure
//
//  Created by Frederic on 2016/12/2.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTShopCartShopsTableViewCell.h"

#import "OTShopCartPriceView.h"
#import <SDWebImage/UIButton+WebCache.h>

#import "OTGoodsModel.h"
#import "OTCommon.h"


@implementation SHGoodsButton

@end


@interface OTShopCartShopsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet SHGoodsButton *itemBtn;

@property (weak, nonatomic) IBOutlet SHGoodsButton *goodsNameBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameTextLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *subtractBtn;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (nonatomic, weak) IBOutlet UITextField *goodsNumTextField;


@end

@implementation OTShopCartShopsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setNameLabel];
    [self setPriceText:@""];
    [self setBackgroundColor:RGB_COLOR(250, 250, 250, 1.0)];
    [self.selectBtn setExclusiveTouch:YES];
    [self.itemBtn setExclusiveTouch:YES];
    [self.subtractBtn setExclusiveTouch:YES];
    [self.addBtn setExclusiveTouch:YES];
    
    self.goodsNumTextField.font = [UIFont systemFontOfSize:15.0];
    [self.goodsNumTextField setTextColor:RGB_COLOR(48, 49, 57, 1.0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGoodsModel:(OTGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    
    [self setCountText:[NSString stringWithFormat:@"%ld", goodsModel.cyrs]];
    [self setPriceText:[NSString stringWithFormat:@"%@", goodsModel.price]];
    self.nameTextLabel.text = goodsModel.tilte;
    NSInteger minCount = 1;
    if (goodsModel.zhuanqu == 1) {
        minCount = 10;
    }
    [self setSubtractBtnWithMinCount:minCount currentCount:[NSString stringWithFormat:@"%ld", goodsModel.cyrs]];
    [self setAddBtnWithMaxCount:(goodsModel.gtotail - goodsModel.cyrs) minCount:minCount currentCount:[NSString stringWithFormat:@"%ld", goodsModel.cyrs]];
    [self setItemBtnImageURL:goodsModel.imgurl];
    
}

- (void)setItemBtnImageURL:(NSString *)urlString {
    if (urlString) {
        NSString *tmp = [urlString copy];
        if (![urlString hasPrefix:@"http"]) {
            tmp = [URL_HOST stringByAppendingString:urlString];
        }
        [self.itemBtn sd_setImageWithURL:[NSURL URLWithString:tmp] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"good_default"]];
    }
}

/**
 *  设置名称label属性
 */
- (void)setNameLabel {
    [self.nameTextLabel setFont:[UIFont systemFontOfSize:12]];
    [self.nameTextLabel setTextColor:RGB_COLOR(49, 56, 65, 1.0)];
}

/**
 *  设置价格内容
 *
 *  @param price 价格
 */
- (void)setPriceText:(NSString*)price {
    NSMutableAttributedString *mutableString = [OTShopCartPriceView setAtttrbleStr:price withFontRMB:10 bigFond:15 smallFond:10];
    [mutableString addAttribute:NSForegroundColorAttributeName value:RGB_COLOR(248, 108, 108, 1.0) range:NSMakeRange(0, mutableString.length)];
    [self.priceLabel setAttributedText:mutableString];
}


/**
 *  设置商品数量
 *
 *  @param countText 数量
 */
- (void)setCountText:(NSString *)countText {
    self.goodsNumTextField.text = countText;
}

- (void)setSelectedBtnSelected:(BOOL)select {
    if (select) {
        [self.selectBtn setImage:[UIImage imageNamed:@"shopping_select_yes_0"] forState:UIControlStateNormal];
    } else {
        [self.selectBtn setImage:[UIImage imageNamed:@"shopping_select_no_0"] forState:UIControlStateNormal];
    }
}

- (void)setSubtractBtnWithMinCount:(NSInteger)minCount currentCount:(NSString *)currCount {
    if (minCount < 0 || minCount >= [currCount integerValue] || [currCount integerValue] <= 1) {
        [self.subtractBtn setImage:[UIImage imageNamed:@"shopping_subtract_no_0"] forState:UIControlStateNormal];
    } else {
        [self.subtractBtn setImage:[UIImage imageNamed:@"shopping_subtract_yes_0"] forState:UIControlStateNormal];
    }
}

- (void)setAddBtnWithMaxCount:(NSInteger)maxCount minCount:(NSInteger)minCount currentCount:(NSString *)currCount {
    if ([currCount integerValue] >= maxCount) {
        [self.addBtn setImage:[UIImage imageNamed:@"shopping_add_no_0"] forState:UIControlStateNormal];
    } else {
        [self.addBtn setImage:[UIImage imageNamed:@"shopping_add_yes_0"] forState:UIControlStateNormal];
    }
}

- (void)setItemBtn:(SHGoodsButton *)itemBtn {
    _itemBtn = itemBtn;
    itemBtn.goodsType = SHGoodsButtonTypeImage;
    itemBtn.exclusiveTouch = YES;
    [itemBtn addGestureRecognizer:[self setupTapGesture]];
}

- (void)setGoodsNameBtn:(SHGoodsButton *)goodsNameBtn {
    _goodsNameBtn = goodsNameBtn;
    goodsNameBtn.goodsType = SHGoodsButtonTypeLabel;
    goodsNameBtn.userInteractionEnabled = NO;
    goodsNameBtn.hidden = YES;
}

- (void)setNameTextLabel:(UILabel *)nameTextLabel {
    _nameTextLabel = nameTextLabel;
    nameTextLabel.userInteractionEnabled = YES;
    [nameTextLabel addGestureRecognizer:[self setupTapGesture]];
}

- (UITapGestureRecognizer *)setupTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTouchesRequired = 1;
    [tap addTarget:self action:@selector(singleTapActionEvent:)];
    return tap;
}

#pragma mark - Action

- (void)singleTapActionEvent:(UIGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(normalCellActionWithModel:type:indexPath:)]) {
        [self.delegate normalCellActionWithModel:self.goodsModel
                                            type:OTShopCartNormalCellActionTypeDetail
                                       indexPath:_indexPath];
    }
}

- (IBAction)selectBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(normalCellActionWithModel:type:indexPath:)]) {
        [self.delegate normalCellActionWithModel:self.goodsModel
                                            type:OTShopCartNormalCellActionTypeSelect
                                       indexPath:_indexPath];
    }
}

- (IBAction)subtractBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(normalCellActionWithModel:type:indexPath:)]) {
        [self.delegate normalCellActionWithModel:self.goodsModel type:OTShopCartNormalCellActionTypeSubtract
                                       indexPath:_indexPath];
    }
}

- (IBAction)addBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(normalCellActionWithModel:type:indexPath:)]) {
        [self.delegate normalCellActionWithModel:self.goodsModel type:OTShopCartNormalCellActionTypeAdd
                                       indexPath:_indexPath];
    }
}

@end
