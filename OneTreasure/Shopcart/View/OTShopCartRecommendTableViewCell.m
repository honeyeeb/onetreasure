//
//  OTShopCartRecommendTableViewCell.m
//  OneTreasure
//
//  Created by Frederic on 2016/12/10.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTShopCartRecommendTableViewCell.h"

#import "OTHomeGoodsCollectionViewCell.h"

#import "OTGoodsModel.h"

#define kItemWidth                                      (SCREEN_WIDTH - 0.5) / 2.0
#define kItemsHeight                                    kItemWidth * 5 / 4

static NSString *const kRecommendGoodsCollectionCellID                          = @"OTRecommendGoodsCollectionCellID";


@interface OTShopCartRecommendTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, OTHomeGoodsCollectionCellDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

// 数据源
@property (strong, nonatomic) NSArray *recommendSource;


@end

@implementation OTShopCartRecommendTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.collectionView];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setShowsVerticalScrollIndicator:NO];
        [_collectionView setBounces:NO];
        [_collectionView setScrollsToTop:NO];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView registerNib:[OTHomeGoodsCollectionViewCell getNib] forCellWithReuseIdentifier:kRecommendGoodsCollectionCellID];
    }
    return _collectionView;
}

- (void)layoutSubviews {
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView setFrame:self.bounds];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getCellHeightWithDataSourceCount:(NSInteger)count {
    NSInteger recommendCount = (count + 1 )/ 2;
    CGFloat height = (recommendCount * (kItemsHeight + 1));
    return height > 0 ? height : 0;
}

- (NSArray *)recommendSource {
    if (!_recommendSource) {
        _recommendSource = [NSArray array];
    }
    return _recommendSource;
}

- (void)setRecommendDataSource:(NSArray *)dataSource {
    _recommendSource = dataSource;
    if (_recommendSource.count > 1) {
        [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } else {
        [_collectionView reloadData];
    }
}

#pragma UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.recommendSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OTHomeGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRecommendGoodsCollectionCellID forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
    cell.delegate = self;
    [cell setGoodsModel:self.recommendSource[indexPath.row] indexPath:indexPath];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kItemWidth, kItemsHeight);
}

//设置如下三个代理方法，使cell自动适应屏幕大小

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.5;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelectGoodsIndexPath:)]) {
        [self.delegate didSelectGoodsIndexPath:indexPath];
    }
}

#pragma mark - OTHomeGoodsCollectionCellDelegate
- (void)didClickShopCartBtnIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didClickShopCartBtnIndexPath:)]) {
        [self.delegate didClickShopCartBtnIndexPath:indexPath];
    }
}

@end
