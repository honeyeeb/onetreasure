//
//  OTFinderGoodsCollectionViewCell.h
//  OneTreasure
//
//  Created by Frederic on 2016/11/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//
// 发现页倒计时cell


#import "OTBaseCollectionViewCell.h"

@class OTFinderGoodsModel;

@interface OTFinderGoodsCollectionViewCell : OTBaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *winerLab;

@property (weak, nonatomic) IBOutlet UILabel *winerNameLab;

@property (weak, nonatomic) IBOutlet UILabel *numberLab;

@property (weak, nonatomic) IBOutlet UILabel *numberCountLab;

@property (weak, nonatomic) IBOutlet UILabel *luckLab;

@property (weak, nonatomic) IBOutlet UILabel *luckNumberLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *timeNumberLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgWidthContraint;

@property (weak, nonatomic) IBOutlet UIView *timerView;
@property (weak, nonatomic) IBOutlet UIButton *timeViewBtn;
@property (weak, nonatomic) IBOutlet UILabel *timerViewLab;


@property (weak, nonatomic) OTFinderGoodsModel *goodsModel;

@property (strong, nonatomic) void (^countDownFinish)(OTFinderGoodsModel *goods);

@end
