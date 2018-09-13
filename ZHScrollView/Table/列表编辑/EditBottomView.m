//
//  EditBottomView.m
//  ZHTableView
//
//  Created by eastmoney on 2018/8/31.
//  Copyright © 2018年 EM. All rights reserved.
//

#import "EditBottomView.h"

@interface EditBottomView()

@property (nonatomic, strong) UIButton *selectCancelBtn;/**< 全选 or 取消 */
@property (nonatomic, strong) UIButton *deleteBtn;/**< 删除 */
@property (nonatomic, strong) UIView *topLine;/**<  */
@property (nonatomic, strong) UIView *verticalLine;/**< 竖直分割线 */
@property (nonatomic,assign) BOOL isShowing;
@end

@implementation EditBottomView


#pragma mark - init
    
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.isShowing = NO;
        
        [self addSubview:self.selectCancelBtn];
        [self addSubview:self.deleteBtn];
        [self addSubview:self.topLine];
        [self addSubview:self.verticalLine];
        [self makeFrame];
    }
    return self;
}
    
#pragma mark - layout
    
- (void)makeFrame{
    self.selectCancelBtn.frame = CGRectMake(0, 0, self.bounds.size.width * 0.5, self.bounds.size.height);
    self.deleteBtn.frame = CGRectMake(self.bounds.size.width * 0.5, 0, self.bounds.size.width * 0.5, self.bounds.size.height);
    self.topLine.frame = CGRectMake(0, 0, self.bounds.size.width, 0.5);
    self.verticalLine.frame = CGRectMake(self.bounds.size.width * 0.5, 12.5, 0.5, self.bounds.size.height - 2 * 12.5);
}
    
#pragma mark - action
    
- (void)selectCancelBtnClick:(UIButton *)btn{
    if (!btn.isSelected) {
        if (self.selecteAllBlock) {
            self.selecteAllBlock();
        }
    }else{
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    }
}
    
- (void)delectBtnClick:(UIButton *)btn{
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}
    
#pragma mark - public
    
//更新选中数量
- (void)updateSelectedCount:(NSUInteger)count{
    self.selectCancelBtn.selected = count;
    
    NSString *title = count > 0 ? [NSString stringWithFormat:@"删除 (%ld)",count] : @"删除";
    self.deleteBtn.enabled = count;
    [self.deleteBtn setTitle:title forState:UIControlStateNormal];
}
    
- (void)showView{
    if (self.isShowing) return;
    CGRect frame = self.frame;
    frame.origin.y = KScreenHeight - KBottomMargin - self.bounds.size.height;
    self.frame = frame;
    self.isShowing = YES;
}
    
- (void)hideView{
    if (!self.isShowing) return;
    CGRect frame = self.frame;
    frame.origin.y = KScreenHeight;
    self.frame = frame;
    self.isShowing = NO;
    
    //重置状态
    [self resetStatus];
}
    
#pragma mark - private
    
- (void)resetStatus{
    self.selectCancelBtn.selected = NO;
    self.deleteBtn.enabled = NO;
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    self.isShowing = NO;
}
    
#pragma mark - getter
    
- (UIButton *)selectCancelBtn{
    if (!_selectCancelBtn) {
        _selectCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectCancelBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_selectCancelBtn setTitleColor:[UIColor colorWithRed:1.0 green:68.0/255.0 blue:0 alpha:1.0] forState:UIControlStateNormal];
        [_selectCancelBtn setTitle:@"取消" forState:UIControlStateSelected];
        [_selectCancelBtn setTitleColor:[UIColor colorWithRed:1.0 green:68.0/255.0 blue:0 alpha:1.0] forState:UIControlStateSelected];
        _selectCancelBtn.backgroundColor = [UIColor clearColor];
        [_selectCancelBtn addTarget: self action:@selector(selectCancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectCancelBtn;
}
    
- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor colorWithRed:1.0 green:68.0/255.0 blue:0 alpha:1.0] forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
        _deleteBtn.enabled = NO;
        _deleteBtn.backgroundColor = [UIColor clearColor];
        _deleteBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        [_deleteBtn addTarget:self action:@selector(delectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
    
- (UIView *)topLine{
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0];
    }
    return _topLine;
}
    
- (UIView *)verticalLine{
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc] init];
        _verticalLine.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0];
    }
    return _verticalLine;
}


@end
