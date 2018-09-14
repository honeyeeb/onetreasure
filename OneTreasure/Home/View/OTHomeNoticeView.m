//
//  OTHomeNoticeView.m
//  OneTreasure
//
//  Created by Frederic on 2016/11/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTHomeNoticeView.h"

#import "OTNoticeTableViewCell.h"
#import "OTBaseTableView.h"
#import "OTNoticeModel.h"

static NSString *const kNoticeTableViewCellID               = @"OTNoticeTableViewCellID";

@interface OTHomeNoticeView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) OTBaseTableView *tableView;

@property (nonatomic, assign) NSInteger totalPageCount;
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation OTHomeNoticeView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.autoScroll = YES;
    
    [self addSubview:self.tableView];
}

- (OTBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[OTBaseTableView alloc] initWithFrame:self.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollsToTop = NO;
        _tableView.pagingEnabled = YES;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerNib:[OTNoticeTableViewCell getNib] forCellReuseIdentifier:kNoticeTableViewCellID];
    }
    return _tableView;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height);
    
    if (self.tableView.contentOffset.y == 0 && self.totalPageCount) {
        
        NSInteger targetIndex = 0;
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:targetIndex inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

- (void)setupTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)automaticScroll {
    if (0 == self.totalPageCount) return;
    
    NSInteger currentIndex = self.tableView.contentOffset.y / self.frame.size.height;
    NSInteger targetIndex = currentIndex + 1;
    
    if (targetIndex == self.totalPageCount) {
        
        targetIndex = 0;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:targetIndex inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
        return;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:targetIndex inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

#pragma mark - UITableViewDelegate/DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.frame.size.height;
}

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OTNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNoticeTableViewCellID forIndexPath:indexPath];
    OTNoticeModel *noticeM = self.dataArray[indexPath.row];
    if (noticeM) {
        NSMutableAttributedString *mutAttStr = [[NSMutableAttributedString alloc] initWithString:@"恭喜 "];
        NSAttributedString *nameAtt = [[NSAttributedString alloc] initWithString:noticeM.nickname attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.98 green:0.48 blue:0.29 alpha:1.00] }];
        NSAttributedString *titleAtt = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" 获得第[%@]期 %@", noticeM.periods, noticeM.title]];
        [mutAttStr appendAttributedString:nameAtt];
        [mutAttStr appendAttributedString:titleAtt];
        cell.noticeLab.attributedText = mutAttStr;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(didSelectedNoticeCellIndexPath:)]) {
        [self.delegate didSelectedNoticeCellIndexPath:indexPath];
    }
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    self.totalPageCount = _dataArray.count;
    
    if (_dataArray.count != 1) {
        
        [self setAutoScroll:self.isAutoScroll];
    } else {
        
    }
    
    [self.tableView reloadData];
}

- (void)setAutoScroll:(BOOL)autoScroll {
    
    _autoScroll = autoScroll;
    
    [self.timer invalidate];
    self.timer = nil;
    
    if (_autoScroll) {
        
        [self setupTimer];
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
    
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

#pragma mark - UIScrollViewDelegate

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
    
    if (!self.dataArray.count) return; // 解决清除timer时偶尔会出现的问题
}

@end
