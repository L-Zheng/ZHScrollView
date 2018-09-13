//
//  WaterFallLayout.m
//  ZHTableView
//
//  Created by eastmoney on 2018/9/13.
//  Copyright © 2018年 EM. All rights reserved.
//

#import "WaterFallLayout.h"
//默认的列数
static const NSInteger DefaultColumnCount = 3;
//每一列之间的间距
static const CGFloat DefaultColumnMargin = 10;
//没一行之间的间距
static const CGFloat DefaultRowMargin = 10;
//边缘间距
static const UIEdgeInsets DefaultEdgeInsets = {10,10,10,10};

@interface WaterFallLayout ()
/** 所有cell的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;
/** 所有列的当前高度 */
@property (nonatomic, strong) NSMutableArray *columnHeights;
/** 内容的高度 */
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation WaterFallLayout

#pragma mark - getter

- (NSMutableArray *)columnHeights{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (NSMutableArray *)attrsArray{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

#pragma mark - private func

/** 上下左右边距 */
- (UIEdgeInsets)edgeInsets{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsOfWaterFallLayout:)]) {
        return [self.delegate edgeInsetsOfWaterFallLayout:self];
    } else {
        return DefaultEdgeInsets;
    }
}

/** 列数 */
- (NSInteger)columnCount{
    if ([self.delegate respondsToSelector:@selector(columnCountOfWaterFallLayout:)]) {
        return [self.delegate columnCountOfWaterFallLayout:self];
    } else {
        return DefaultColumnCount;
    }
}

/** 行间距 */
- (CGFloat)rowMargin{
    if ([self.delegate respondsToSelector:@selector(rowMarginOfWaterFallLayout:)]) {
        return [self.delegate rowMarginOfWaterFallLayout:self];
    } else {
        return DefaultRowMargin;
    }
}

/** 列间距 */
- (CGFloat)columnMargin{
    if ([self.delegate respondsToSelector:@selector(columnMarginOfWaterFallLayout:)]) {
        return [self.delegate columnMarginOfWaterFallLayout:self];
    } else {
        return DefaultColumnMargin;
    }
}

#pragma mark - private func override

- (void)prepareLayout{
    [super prepareLayout];
    
    //collection内容高度
    self.contentHeight = 0;
    
    //每列保存高度
    [self.columnHeights removeAllObjects];
    
    NSInteger columnCount = [self columnCount];
    for (NSInteger i = 0; i < columnCount; i++) {
        [self.columnHeights addObject:@([self edgeInsets].top)];
    }
    
    //cell布局属性
    [self.attrsArray removeAllObjects];
    
    //创建cell布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        // 创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        // 获取indexPath位置cell对应的布局属性
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        //        UICollectionViewLayoutAttributes *headerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        //        UICollectionViewLayoutAttributes *footerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
        //        [self.attrsArray addObject:headerAttrs];
        [self.attrsArray addObject:attrs];
        //        [self.attrsArray addObject:footerAttrs];
    }
}

/** 创建header footer布局属性 */
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        return [super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
    }else if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]){
        return [super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    }else{
        return [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    }
}

/** 创建cell布局属性 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    
    //计算cell宽高
    CGFloat w = (collectionViewW - [self edgeInsets].left - [self edgeInsets].right - ([self columnCount] - 1) * [self columnMargin]) / [self columnCount];
    CGFloat h = [self.delegate waterFallLayout:self heightForItemAtIndexPath:indexPath itemWidth:w];
    
    //计算高度最小的列
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 0; i < [self columnCount]; i++) {
        CGFloat currentColumnHeight = [self.columnHeights[i] doubleValue];
        if (minColumnHeight > currentColumnHeight) {
            minColumnHeight = currentColumnHeight;
            destColumn = i;
        }
    }
    
    //计算cell位置
    CGFloat x = [self edgeInsets].left + destColumn * (w + [self columnMargin]);
    CGFloat y = minColumnHeight;
    if (y != [self edgeInsets].top) {
        y += [self rowMargin];
    }
    attrs.frame = CGRectMake(x, y, w, h);
    
    //保存每列高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    //计算collection的contentSize大小
    CGFloat columnHeight = [self.columnHeights[destColumn] doubleValue];
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    
    return attrs;
}

/** cell布局属性 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrsArray;
}

/** contentSize大小 */
- (CGSize)collectionViewContentSize{
    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);
}

@end
