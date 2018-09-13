//
//  MultiTableLinkFooterView.m
//  ZHTableView
//
//  Created by eastmoney on 2018/8/14.
//  Copyright © 2018年 EM. All rights reserved.
//

#import "MultiTableLinkFooterView.h"
#import "MultiCollectionCell.h"

@interface MultiTableLinkFooterView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,retain) NSMutableArray *dataArray;
@end

@implementation MultiTableLinkFooterView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0];
        
        [self addSubview:self.collectionView];
        [self.collectionView reloadData];
    }
    return self;
}

#pragma mark - getter

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        NSArray *data = @[
                          @{
                              @"title" : @"collection1"
                              },
                          @{
                              @"title" : @"collection2"
                              },
                          @{
                              @"title" : @"collection3"
                              }
                          ];
        _dataArray = [NSMutableArray arrayWithArray:data];
    }
    return _dataArray;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = self.bounds.size;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //此方法ios8 不支持 使用代理
        //        layout.headerReferenceSize = CGSizeMake(KScreenWidth, QuotesSelfGridCollectionHeaderHeight);
        
        CGFloat systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
        if (systemVersion >= 9.0) {
            layout.sectionHeadersPinToVisibleBounds = YES;
            layout.sectionFootersPinToVisibleBounds = YES;
        }
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        
        for (NSInteger i = 0; i < self.dataArray.count; i++) {
            [_collectionView registerClass:[MultiCollectionCell class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"MultiCollectionCellID--%ld",i]];
        }
        
        //注意控制器遵守代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.allowsSelection = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = YES;
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate

//个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

//cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MultiCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"MultiCollectionCellID--%ld",indexPath.item] forIndexPath:indexPath];
    cell.dataDic = self.dataArray[indexPath.item];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSInteger num = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubCollectionViewScrollNotification" object:nil userInfo:nil];
}

#pragma mark - public

+ (CGFloat)footerHeight{
    return KScreenHeight - KNavHeight - 20;
}

@end
