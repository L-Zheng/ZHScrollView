//
//  DemoCollecitonController.m
//  ZHTableView
//
//  Created by eastmoney on 2018/9/12.
//  Copyright © 2018年 EM. All rights reserved.
//

#import "DemoCollecitonController.h"

@interface DemoCollecitonController ()

@end

@implementation DemoCollecitonController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - getter

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //列间距【竖向时--列间距  横向时--行间距】：相邻两个的间距
        layout.minimumInteritemSpacing = 10;
        //        行间距
        layout.minimumLineSpacing = 20;
        
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGFloat cellWidth = 0;
        //左右上下缩进
        if (layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
            layout.sectionInset = UIEdgeInsetsMake(0,20,0,20);
            CGFloat cellCountEachRow = 3.0;
            cellWidth = (KScreenWidth - (layout.sectionInset.left + layout.sectionInset.right) - layout.minimumInteritemSpacing * (cellCountEachRow - 1)) / cellCountEachRow;
        }else{
            layout.sectionInset = UIEdgeInsetsMake(20,0,20,0);
            CGFloat cellCountEachCol = 4.0;
            cellWidth = (KScreenHeight - KNavHeight - KBottomMargin - (layout.sectionInset.top + layout.sectionInset.bottom) - layout.minimumInteritemSpacing * (cellCountEachCol - 1)) / cellCountEachCol;
        }
        
        layout.itemSize = CGSizeMake(cellWidth, cellWidth);
        
        if (@available(iOS 9.0, *)){
            layout.sectionHeadersPinToVisibleBounds = YES;
            layout.sectionFootersPinToVisibleBounds = YES;
        }
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, KNavHeight, KScreenWidth, KScreenHeight - KNavHeight - KBottomMargin) collectionViewLayout:layout];
        
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.showsHorizontalScrollIndicator = YES;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.alwaysBounceHorizontal = YES;
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCellID"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ColectionHeaderID"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ColectionFooterID"];
    }
    return _collectionView;
}

#pragma mark - collection delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
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
    //    cell.item = self.items[indexPath.item];
    return cell;
}

//组头 组尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableView = nil;
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ColectionHeaderID" forIndexPath:indexPath];
        
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ColectionFooterID" forIndexPath:indexPath];
    }else{
        
    }
    UILabel *label = [reusableView viewWithTag:9999];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:reusableView.bounds];
        label.tag = 9999;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [reusableView addSubview:label];
    }
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        label.text = [NSString stringWithFormat:@"header---%ld",indexPath.section];
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        label.text = [NSString stringWithFormat:@"footer---%ld",indexPath.section];
    }else{
    }
    
    reusableView.backgroundColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.3];
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

//实现点击时(手指未松开)的显示状态与点击后(手指松开)的显示状态
/*
 事件的处理顺序如下：
 
 手指按下
 shouldHighlightItemAtIndexPath (如果返回YES则向下执行，否则执行到这里为止)
 didHighlightItemAtIndexPath (高亮)
 手指松开
 didUnhighlightItemAtIndexPath (取消高亮)
 shouldSelectItemAtIndexPath (如果返回YES则向下执行，否则执行到这里为止)
 didSelectItemAtIndexPath (执行选择事件)
 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell.contentView setBackgroundColor:[UIColor purpleColor]];
}

- (void)collectionView:(UICollectionView *)collectionView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell.contentView setBackgroundColor:[UIColor yellowColor]];
}

#pragma mark - UICollectionViewDelegateFlowLayout

//组头高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    UICollectionViewFlowLayout *layout = collectionViewLayout;
    if (layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        return CGSizeMake(KScreenWidth, 44);
    }else{
        return CGSizeMake(44, KScreenHeight);
    }
    
}

//组尾高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    UICollectionViewFlowLayout *layout = collectionViewLayout;
    if (layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        return CGSizeMake(KScreenWidth, 44);
    }else{
        return CGSizeMake(44, KScreenHeight);
    }
}

//////Cell的尺寸
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake(80, 80);
//}
//////collectionView(指定区)的边距
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}
//////行间距 == UICollectionViewFlowLayout的minimumLineSpacing属性
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    return 10;
//}
//////列间距 == UICollectionViewFlowLayout的minimumInteritemSpacing属性
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return 0;
//}

@end
