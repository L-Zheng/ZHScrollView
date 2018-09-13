//
//  WaterFallLayout.h
//  ZHTableView
//
//  Created by eastmoney on 2018/9/13.
//  Copyright © 2018年 EM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WaterFallLayout;

@protocol WaterFallLayoutDelegate <NSObject>
@required
/** cell高度 */
- (CGFloat)waterFallLayout:(WaterFallLayout *)waterFallLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;
@optional
/** 列数 */
- (CGFloat)columnCountOfWaterFallLayout:(WaterFallLayout *)waterFallLayout;
/** 列间距 */
- (CGFloat)columnMarginOfWaterFallLayout:(WaterFallLayout *)waterFallLayout;
/** 行间距 */
- (CGFloat)rowMarginOfWaterFallLayout:(WaterFallLayout *)waterFallLayout;
/** 上下左右边距 */
- (UIEdgeInsets)edgeInsetsOfWaterFallLayout:(WaterFallLayout *)waterFallLayout;

@end

@interface WaterFallLayout : UICollectionViewFlowLayout

@property (nonatomic ,weak) id<WaterFallLayoutDelegate> delegate;

@end
