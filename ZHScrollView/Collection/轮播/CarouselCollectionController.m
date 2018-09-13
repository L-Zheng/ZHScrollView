//
//  CarouselCollectionController.m
//  ZHTableView
//
//  Created by eastmoney on 2018/9/13.
//  Copyright © 2018年 EM. All rights reserved.
//

#import "CarouselCollectionController.h"

#define MaxSections 3

@interface CarouselCollectionController ()
@property (nonatomic,strong) UIPageControl *pageContol;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic,retain) NSMutableArray *items;
@end

@implementation CarouselCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.pageContol];
    
    [self setupData];
}

#pragma mark - getter

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGFloat cellHeight = 150;
        CGFloat cellWidth = KScreenWidth;
        
        layout.itemSize = CGSizeMake(cellWidth, cellHeight);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, KNavHeight + 100, cellWidth, cellHeight) collectionViewLayout:layout];
        
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.pagingEnabled = YES;
        _collectionView.directionalLockEnabled = YES;
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCellID"];
    }
    return _collectionView;
}

- (UIPageControl *)pageContol{
    if (!_pageContol) {
        _pageContol = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView.frame) + 10, KScreenWidth, 10)];
        _pageContol.backgroundColor = [UIColor grayColor];
    }
    return _pageContol;
}

#pragma mark - data

- (void)setupData{
    self.items = [NSMutableArray array];
    
    [self removeTimer];
    
    for (NSInteger i = 0; i < 5; i++) {
        [self.items addObject:@{}];
    }
    
    if (self.items.count == 0 || self.items == nil) return;
    
    [self.collectionView reloadData];
    self.pageContol.numberOfPages = self.items.count;
    
    //如果该collectionView不在tableViewcell里面 而在tableView的头部的View里面  需要在这里调用[self setNeedsLayout]方法
//    [self setNeedsLayout];
    
    [self addTimer];
}

#pragma mark - action

- (void)addTimer{
    if (self.timer != nil) return;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)removeTimer{
    if (self.timer == nil) return;
    [self.timer invalidate];
    self.timer = nil;
}

/** 回到中间一组 */
- (NSIndexPath *)resetIndexPath{
    // 当前正在展示的位置
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    
    //是中间组的数据
    if (currentIndexPath.section == MaxSections/2) {
        return currentIndexPath;
    }
    
    // 显示回最中间那组的数据
    NSIndexPath *middleIndexPath = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:MaxSections/2];
    //滚动之前  判断是否有数据
    if (self.items == nil || self.items.count == 0) return nil;
    [self.collectionView scrollToItemAtIndexPath:middleIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    return middleIndexPath;
}

- (void)nextPage{
    // 显示回最中间那组的数据
    NSIndexPath *middleIndexPath = [self resetIndexPath];
    if (middleIndexPath == nil) return;
    
    // 下一个需要展示的位置
    NSInteger nextItem = middleIndexPath.item + 1;
    NSInteger nextSection = middleIndexPath.section;
    if (nextItem == self.items.count) {
        nextItem = 0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    // 滚动到下一个位置
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return (self.items.count == 0 || self.items == nil) ? 0 : MaxSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCellID" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255.0)/255.0 green:arc4random_uniform(255.0)/255.0 blue:arc4random_uniform(255.0)/255.0 alpha:0.5];
    UILabel *label = [cell viewWithTag:9999];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:cell.bounds];
        label.tag = 9999;
        label.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:label];
    }
    label.text = [NSString stringWithFormat:@"组-%ld 个-%ld",indexPath.section,indexPath.item];
    return cell;
}

#pragma mark  - UICollectionViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
    //开始拖拽的时候先回到中间那组
    [self resetIndexPath];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.items == nil || self.items.count == 0) return;
    
    int page = (int)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5) % self.items.count;
    self.pageContol.currentPage = page;
}


@end
