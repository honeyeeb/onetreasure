//
//  OTHomeBannerSubjectView.m
//  OneTreasure
//
//  Created by Frederic on 2016/11/25.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTHomeBannerSubjectView.h"
#import "OTHomeBannerItemCell.h"
#import "OTBaseCollectionView.h"

#import <SDWebImage/UIImageView+WebCache.h>

static NSString * const HomeBannerItemID = @"OTHomeBannerCollectionItemID";

@implementation OTBannerViewParam
@end



@interface OTHomeBannerSubjectView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) OTBaseCollectionView                  *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout            *famousAndOrgLayout;
@property (nonatomic, strong) UIPageControl                         *pageControl;
@property (nonatomic, assign) NSInteger                             totalPageCount;
@property (nonatomic, weak) NSTimer                                 *timer;

@end

@implementation OTHomeBannerSubjectView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    
    self.isAutoScroll = YES;
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
}

- (void)setupTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)automaticScroll {
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        STRONGSELF
        if (0 == strongSelf.totalPageCount) return;
        
        NSInteger currentIndex = strongSelf.collectionView.contentOffset.x / SCREEN_WIDTH;
        NSInteger targetIndex = currentIndex + 1;
        
        if (targetIndex == strongSelf.totalPageCount) {
            
            targetIndex = strongSelf.totalPageCount * 0.5;
            [strongSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            return;
        }
        [strongSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    });
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.totalPageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    OTBannerViewParam *model = self.subjectList[indexPath.item % self.subjectList.count];
    OTHomeBannerItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeBannerItemID forIndexPath:indexPath];
    
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"banner_default"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//    }];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"banner_0" ofType:@"jpg"]]];
    if (!image) {
        image = [UIImage imageNamed:@"banner_default"];
    }
    cell.imageView.image = image;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if([self.delegate respondsToSelector:@selector(didSelectedHomeBannerCellIndex:)]){
        
        [self.delegate didSelectedHomeBannerCellIndex:(indexPath.item % self.subjectList.count)];
    }
}

#pragma mark - getters and setters

- (OTBaseCollectionView *)collectionView {
    
    if(!_collectionView){
        
        _collectionView = [[OTBaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height) collectionViewLayout:self.famousAndOrgLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollsToTop = NO;
        [_collectionView registerClass:[OTHomeBannerItemCell class] forCellWithReuseIdentifier:HomeBannerItemID];
    }
    
    return _collectionView;
}

- (UICollectionViewFlowLayout *)famousAndOrgLayout {
    
    if(!_famousAndOrgLayout){
        
        _famousAndOrgLayout = [[UICollectionViewFlowLayout alloc] init];
        _famousAndOrgLayout.itemSize = CGSizeMake(SCREEN_WIDTH, self.frame.size.height);
        _famousAndOrgLayout.minimumInteritemSpacing = 0;
        _famousAndOrgLayout.minimumLineSpacing = 0;
        _famousAndOrgLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    return _famousAndOrgLayout;
}

- (UIPageControl *)pageControl {
    
    if (!_pageControl) {
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = RGB_COLOR(241, 96, 86, 1.0);
    }
    return _pageControl;
}

- (void)setSubjectList:(NSArray *)subjectList {
    
    _subjectList = subjectList;
    
    self.totalPageCount = _subjectList.count * 100;
    
    if (_subjectList.count != 1) {
        
        self.collectionView.scrollEnabled = YES;
        [self setIsAutoScroll:self.isAutoScroll];
    } else {
        
        self.collectionView.scrollEnabled = NO;
    }
    [self setupPageControlWithCount:_subjectList.count];
    
    [self.collectionView reloadData];
}

- (void)setupPageControlWithCount:(NSInteger)count{
    
    if (count < 1) {
        
        return;
    }
    self.pageControl.numberOfPages = count;
    CGRect frame = self.pageControl.frame;
    frame.size.width = SCREEN_WIDTH;
    self.pageControl.frame = frame;
}

- (void)setIsAutoScroll:(BOOL)isAutoScroll {
    
    _isAutoScroll = isAutoScroll;
    
    [self.timer invalidate];
    self.timer = nil;
    
    if (_isAutoScroll) {
        
        [self setupTimer];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height);
    self.famousAndOrgLayout.itemSize = CGSizeMake(SCREEN_WIDTH, self.frame.size.height);
    self.pageControl.frame = CGRectMake(0, self.frame.size.height - 37, SCREEN_WIDTH , 37);
    
    if (self.collectionView.contentOffset.x == 0 && self.totalPageCount) {
        
        NSInteger targetIndex = 0;
        targetIndex = self.totalPageCount * 0.5;
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        
        [self.timer invalidate];
        self.timer = nil;
    }
}

//解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc {
    
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger itemIndex = (scrollView.contentOffset.x + SCREEN_WIDTH * 0.5) / SCREEN_WIDTH;
    
    if (!self.subjectList.count) return; // 解决清除timer时偶尔会出现的问题
    
    NSInteger indexOnPageControl = itemIndex % self.subjectList.count;
    self.pageControl.currentPage = indexOnPageControl;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.isAutoScroll) {
        
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.isAutoScroll) {
        
        [self setupTimer];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {

    if (!self.subjectList.count) return; // 解决清除timer时偶尔会出现的问题
}

@end
