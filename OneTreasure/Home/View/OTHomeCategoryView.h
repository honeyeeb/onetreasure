//
//  OTHomeCategoryView.h
//  OneTreasure
//
//  Created by Frederic on 2016/11/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//
//  分类

#import <UIKit/UIKit.h>


@protocol OTHomeCategoryViewDelegate <NSObject>

@optional
- (void)didSelectHomeCategoryViewItemIndex:(NSInteger)index;

@end

@interface OTHomeCategoryView : UIView

@property (nonatomic, weak) id<OTHomeCategoryViewDelegate>              delegate;
@property (nonatomic, strong) NSArray                                   *cateList;
@property (nonatomic, strong) UICollectionView                          *collectionView;

- (void)collectionViewScrollToCellIndex:(NSInteger)index;

@end
