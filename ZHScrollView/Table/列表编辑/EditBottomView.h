//
//  EditBottomView.h
//  ZHTableView
//
//  Created by eastmoney on 2018/8/31.
//  Copyright © 2018年 EM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditBottomView : UIView
    
@property (nonatomic,copy) void (^selecteAllBlock) (void);/**< 选中全部回调 */
@property (nonatomic,copy) void (^cancelBlock) (void);/**< 取消回调 */
@property (nonatomic,copy) void (^deleteBlock) (void);/**< 删除回调 */
    //更新选中数量
- (void)updateSelectedCount:(NSUInteger)count;
    
- (void)showView;
- (void)hideView;

@end
