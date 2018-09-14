//
//  BaseCollectionViewController.m
//  ZHTableView
//
//  Created by eastmoney on 2018/9/12.
//  Copyright © 2018年 EM. All rights reserved.
//

#import "BaseCollectionViewController.h"

@interface BaseCollectionViewController ()
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation BaseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    if (@available(iOS 11.0, *)){
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.collectionView];
}

#pragma mark - getter

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //        列间距
        layout.minimumInteritemSpacing = 10;
        //        行间距
        layout.minimumLineSpacing = 10;
        //        左右上下缩进
        layout.sectionInset = UIEdgeInsetsMake(0,20,0,20);
        
        CGFloat cellCountEachLine = 3.0;
        CGFloat cellWidth = (KScreenWidth - (layout.sectionInset.left + layout.sectionInset.right) - layout.minimumInteritemSpacing * (cellCountEachLine - 1)) / cellCountEachLine;
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
        //        _collectionView.showsHorizontalScrollIndicator = YES;
        _collectionView.alwaysBounceVertical = YES;
        //        _collectionView.alwaysBounceHorizontal = YES;
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"BaseCollectionViewCellID"];
        //        [_collectionView registerClass:[CollectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CollectionHeaderID];
        //        [_collectionView registerClass:[CollectionFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:CollectionFooterID];
    }
    return _collectionView;
}

#pragma mark - collection delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BaseCollectionViewCellID" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255.0)/255.0 green:arc4random_uniform(255.0)/255.0 blue:arc4random_uniform(255.0)/255.0 alpha:0.5];
    return cell;
}


@end
