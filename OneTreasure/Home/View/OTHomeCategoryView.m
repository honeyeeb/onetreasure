//
//  OTHomeCategoryView.m
//  OneTreasure
//
//  Created by Frederic on 2016/11/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTHomeCategoryView.h"

#import "OTCategoryCollectionViewCell.h"
#import "OTHomeCategoryModel.h"

static NSString * const CateScrollCellIdentifier        = @"OTCateScrollCellIdentifier";


@interface OTHomeCategoryView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout                *flowLayout;
@property (nonatomic, assign) NSInteger                                 homeCateId;

@end

@implementation OTHomeCategoryView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    
    [self addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.cateList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OTHomeCategoryModel *model = self.cateList[indexPath.item];
    OTCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CateScrollCellIdentifier forIndexPath:indexPath];
    
    [cell.titleBtn setTitle:model.categoryTitle forState:UIControlStateNormal];
    
    if (model.sortType == self.homeCateId) {
        
        cell.titleBtn.selected = YES;
        cell.lineView.hidden = NO;
    }
    else {
        
        cell.titleBtn.selected = NO;
        cell.lineView.hidden = YES;
    }
    
    return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OTHomeCategoryModel *model = self.cateList[indexPath.item];
    
    CGSize itemSize = [model.categoryTitle boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:15.0] } context:nil].size;
    
    return CGSizeMake(itemSize.width + 30.0, self.frame.size.height);
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(didSelectHomeCategoryViewItemIndex:)]) {
        
        [self collectionViewScrollToCellIndex:indexPath.item];
        [self.delegate didSelectHomeCategoryViewItemIndex:indexPath.item];
    }
}

- (void)collectionViewScrollToCellIndex:(NSInteger)index {
    
    if (index >= 0) {
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self refreshCollectionCellWithIndex:index];
    }
}

- (void)refreshCollectionCellWithIndex:(NSInteger)index {
    
    OTHomeCategoryModel *model = self.cateList[index];
    self.homeCateId = model.sortType;
    [self.collectionView reloadData];
}

#pragma mark - Setters And Getters

- (void)setCateList:(NSArray *)cateList {
    
    _cateList = cateList;
    
    [self refreshCollectionCellWithIndex:0];
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height) collectionViewLayout:self.flowLayout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[OTCategoryCollectionViewCell class] forCellWithReuseIdentifier:CateScrollCellIdentifier];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    
    if (!_flowLayout) {
        
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

@end
