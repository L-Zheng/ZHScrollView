//
//  WaterFallController.m
//  ZHTableView
//
//  Created by eastmoney on 2018/9/13.
//  Copyright © 2018年 EM. All rights reserved.
//

#import "WaterFallController.h"
#import "WaterFallLayout.h"

@interface WaterFallController ()<WaterFallLayoutDelegate>
@property (nonatomic,strong) WaterFallLayout *waterFallLayout;
@end

@implementation WaterFallController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - getter

- (WaterFallLayout *)waterFallLayout{
    if (!_waterFallLayout) {
        _waterFallLayout = [[WaterFallLayout alloc] init];
        _waterFallLayout.delegate = self;
    }
    return _waterFallLayout;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.view.bounds.size.width / 3, 80);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, KNavHeight, KScreenWidth, KScreenHeight - KNavHeight - KBottomMargin) collectionViewLayout:self.waterFallLayout];
        
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCellID"];
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCellID" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255.0)/255.0 green:arc4random_uniform(255.0)/255.0 blue:arc4random_uniform(255.0)/255.0 alpha:0.5];
    return cell;
}

#pragma mark - layout delegate

- (CGFloat)waterFallLayout:(WaterFallLayout *)waterFallLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth{
    //假定 w : h = 2:3 ~ 2:7
    return itemWidth / (2.0 / (3.0 + (float)arc4random_uniform(4)));
}

/** 列数 */
- (CGFloat)columnCountOfWaterFallLayout:(WaterFallLayout *)waterFallLayout{
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        return 3;
    } else {
        return 5;
    }
}


#pragma mark - layout

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [UIView animateWithDuration:0.25 animations:^{
        self.collectionView.frame = CGRectMake(0, KNavHeight, KScreenWidth, KScreenHeight - KNavHeight - KBottomMargin);
        [self.collectionView reloadData];
    }];
}



@end
