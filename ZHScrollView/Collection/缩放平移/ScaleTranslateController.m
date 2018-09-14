//
//  ScaleTranslateController.m
//  ZHScrollView
//
//  Created by eastmoney on 2018/9/14.
//  Copyright © 2018年 EM. All rights reserved.
//

#import "ScaleTranslateController.h"

#define UICollectionCellMarginLeftRight (37.5 * 2)
#define UICollectionCellPadding 15.0
#define UICollectionViewSupplementHeight (42.0 * 2)

static NSInteger currentModel = 1;

@interface ScaleTranslateLayout : UICollectionViewFlowLayout
@end
@implementation ScaleTranslateLayout
// 返回区域内每一个元素的布局属性 （重写的话， 相当于 要给每一个元素增添属性）
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    // 系统父类写的方法， 系统子类必须调用父类，进行执行(只是对部分属性进行修改,所以不必一个个进行设置布局属性)
    CGFloat collectionW = self.collectionView.bounds.size.width;
    
    NSArray *layoutAtts =  [super layoutAttributesForElementsInRect:rect];
    CGFloat collectionViewCenterX = collectionW * 0.5;
    CGFloat contentOffsetX = self.collectionView.contentOffset.x;
    for (UICollectionViewLayoutAttributes *layoutAtt in layoutAtts) {
        CGFloat centerX = layoutAtt.center.x;
        // 形变值，根据当前cell 距离中心位置，的远近  进行反比例缩放。 （不要忘记算其偏移量的值。）
        
        if (currentModel == 1) {
            //            4.0  自己定义  第一个cell的scale为1  第二个cell的scale 越小  显示的cell越小 就会导致相邻cell之间的间距越大  根据实际情况调整
            CGFloat scale = 1 - ABS((centerX - collectionViewCenterX - contentOffsetX)/collectionW / 4.0);
            //            NSLog(@"--------------------");
            //            NSLog(@"%f",scale);
            //            NSLog(@"--------------------");
            // 给 布局属性  添加形变
            layoutAtt.transform = CGAffineTransformMakeScale(scale, scale);
        }else if (currentModel == 2){
            //计算比例    n * (KScreenWidth - (37.5 * 2) + 15) / KScreenWidth
            //        n = 1  scale = 0.84   KScreenWidth越大scale越大
            //        (1 - (UICollectionCellMarginLeftRight * 2 - UICollectionCellPadding) / collectionW)
            
            CGFloat distance = ABS((centerX - collectionViewCenterX - contentOffsetX)/collectionW) * (UICollectionViewSupplementHeight / 2.0 / (1 - (UICollectionCellMarginLeftRight * 2 - UICollectionCellPadding) / collectionW));
            //        NSLog(@"---------111-----------");
            //        NSLog(@"%f",distance);
            //        NSLog(@"---------111-----------");
            //        2.800000  2.240000  1.680000  1.120000  0.560000   0.000000  0.560000  1.120000  1.680000  2.240000  2.800000
            CGAffineTransform scaleForm = CGAffineTransformMakeScale(1, 1);
            layoutAtt.transform = CGAffineTransformTranslate(scaleForm, 0, distance);
        }
        
    }
    return layoutAtts;
}
// 是否允许 运行时，（在无效(未确定)的layout 情况下）改变bounds
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
// 通过目标移动的偏移量， 提取期望偏移量  （一般情况下，期望偏移量，就是 目标偏移量）
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    // 根据偏移量 ， 确定区域
    CGRect rect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    // 将屏幕所显示区域的 元素布局 取出。
    NSArray *layoutAtts = [super layoutAttributesForElementsInRect:rect];
    CGFloat minMargin = MAXFLOAT;
    CGFloat collectionViewCenterX = self.collectionView.frame.size.width * 0.5;
    CGFloat contentOffsetX = proposedContentOffset.x;
    // 取出区域内元素， 并根据其中心位置， 与视图中心位置 进行比较， 比出最小的距离差
    for (UICollectionViewLayoutAttributes *layoutAtt in layoutAtts) {
        CGFloat margin = layoutAtt.center.x - contentOffsetX - collectionViewCenterX;
        if (ABS(margin) < ABS(minMargin)) {
            minMargin = margin;
        }
    }
    //    NSLog(@"%f",minMargin);
    // 期望偏移量 加上差值， 让整体，沿差值 反方向移动，这样的话， 最近的一个，刚好在中心位置
    proposedContentOffset.x += minMargin;
    return proposedContentOffset;
}
@end



@interface ScaleTranslateController ()
@property (nonatomic, strong) UIPageControl *pageContol;
@property (nonatomic,retain) NSMutableArray *items;
@end

@implementation ScaleTranslateController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn setTitle:@"缩放" forState:UIControlStateNormal];
    [btn setTitle:@"平移" forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(switchMode:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [self.view addSubview:self.pageContol];
    [self setupData];
}

- (void)switchMode:(UIButton *)btn{
    btn.selected = !btn.isSelected;
    currentModel = btn.isSelected ? 2 : 1;
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self.collectionView reloadData];
}

#pragma mark - data

- (void)setupData{
    self.items = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 8; i++) {
        [self.items addObject:@{}];
    }
    
    if (self.items.count == 0 || self.items == nil) return;
    
    [self.collectionView reloadData];
    self.pageContol.numberOfPages = self.items.count;
}

#pragma mark - getter

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        ScaleTranslateLayout *layout = [[ScaleTranslateLayout alloc] init];
        //列间距
        //layout.minimumInteritemSpacing = 10;
        //行间距
        layout.minimumLineSpacing = UICollectionCellPadding;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGFloat collecetionX = 0;
        CGFloat collecetionY = KNavHeight;
        CGFloat collecetionW = KScreenWidth;
        CGFloat collecetionH = KScreenHeight - KNavHeight - KBottomMargin - 30;
        
        layout.itemSize = CGSizeMake(collecetionW - UICollectionCellMarginLeftRight * 2, collecetionH - UICollectionViewSupplementHeight);
        layout.sectionInset = UIEdgeInsetsMake(0, UICollectionCellMarginLeftRight, 0, UICollectionCellMarginLeftRight);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(collecetionX, collecetionY, collecetionW, collecetionH) collectionViewLayout:layout];
        
        _collectionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.alwaysBounceHorizontal = YES;
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCellID"];
    }
    return _collectionView;
}

- (UIPageControl *)pageContol{
    if (!_pageContol) {
        _pageContol = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView.frame) + 10, KScreenWidth, 10)];
        _pageContol.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _pageContol.currentPageIndicatorTintColor = [UIColor orangeColor];
        //        _pageContol.pageIndicatorTintColor = [UIColor getColor:218 :218 :218];
        
    }
    return _pageContol;
}

#pragma mark - collection delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCellID" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255.0)/255.0 green:arc4random_uniform(255.0)/255.0 blue:arc4random_uniform(255.0)/255.0 alpha:0.5];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat collectionW = self.collectionView.bounds.size.width;
    
    //    分析每一个cell处在中间时的范围  找规律
    //         ~ 0                               0
    //    0 ~ 300 + 15                           1
    //    300 + 15 ~ 2 * (300 + 15)              2
    //    2 * (300 + 15) ~ 3 * (300 + 15)        3
    CGFloat calculateOffsetX = currentOffsetX - UICollectionCellMarginLeftRight - (collectionW - UICollectionCellMarginLeftRight * 2 + UICollectionCellPadding / 2.0) + collectionW / 2.0;
    int page = 0;
    if (calculateOffsetX <= 0) {
        page = 0;
    }else{
        page = (int)(calculateOffsetX / (collectionW - UICollectionCellMarginLeftRight * 2 + UICollectionCellPadding)) + 1;
    }
    
    self.pageContol.currentPage = page;
}

///通过代理 使其目标位置targetContentOffset位于屏幕中央 ==  layout的targetContentOffsetForProposedContentOffset方法
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    CGPoint originalTargetContentOffset = CGPointMake(targetContentOffset->x, targetContentOffset->y);
//    CGPoint targetCenter = CGPointMake(originalTargetContentOffset.x + CGRectGetWidth(self.collectionView.bounds)/2, CGRectGetHeight(self.collectionView.bounds) / 2);
//    NSIndexPath *indexPath = nil;
//    NSInteger i = 0;
//    while (indexPath == nil) {
//        targetCenter = CGPointMake(originalTargetContentOffset.x + CGRectGetWidth(self.collectionView.bounds)/2 + 10*i, CGRectGetHeight(self.collectionView.bounds) / 2);
//        indexPath = [self.collectionView indexPathForItemAtPoint:targetCenter];
//        i++;
//    }
//    //    self.selectedIndex = indexPath;
//    //这里用attributes比用cell要好很多，因为cell可能因为不在屏幕范围内导致cellForItemAtIndexPath返回nil
//    UICollectionViewLayoutAttributes *attributes = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
//    if (attributes) {
//        *targetContentOffset = CGPointMake(attributes.center.x - CGRectGetWidth(self.collectionView.bounds)/2, originalTargetContentOffset.y);
//    } else {
//        NSLog(@"center is %@; indexPath is {%@, %@}; cell is %@",NSStringFromCGPoint(targetCenter), @(indexPath.section), @(indexPath.item), attributes);
//    }
//}


@end
