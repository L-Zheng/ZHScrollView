//
//  BaseCollectionViewController.h
//  ZHTableView
//
//  Created by eastmoney on 2018/9/12.
//  Copyright © 2018年 EM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionViewController : UIViewController{
    UICollectionView *_collectionView;
}

@property (nonatomic, strong, readonly) UICollectionView *collectionView;

@end
