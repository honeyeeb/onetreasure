//
//  OTCollectionViewController.h
//  OneTreasure
//
//  Created by Frederic on 2016/11/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTBaseViewController.h"

@interface OTCollectionViewController : OTBaseViewController

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;


#pragma mark - MJRefresh
/// 添加下拉刷新
- (void)setMJRefreshHeader:(void (^)())block;
/// 添加上拉刷新
- (void)setMJRefreshFooter:(void (^)())block;

- (void)endMJHeaderRefresh;

- (void)endMHFooterRefresh;

@end
