//
//  EditTableCell.m
//  ZHTableView
//
//  Created by eastmoney on 2018/8/30.
//  Copyright © 2018年 EM. All rights reserved.
//

#import "EditTableCell.h"
#import "EditItem.h"

@interface EditTableCell ()
@end

@implementation EditTableCell

#pragma mark - init
    
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
//        背景默认为白色
//        self.backgroundColor = [UIColor clearColor];
        //取消拖动cell时的蓝色背景
        self.multipleSelectionBackgroundView = [[UIView alloc]init];
        self.multipleSelectionBackgroundView.backgroundColor = [UIColor clearColor];
        
        //设置内容背景透明  否则选中时self.backgroundView的颜色状态会被contentView遮挡
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.backgroundView = [UIView new];
    }
    return self;
}
    
- (void)setItem:(EditItem *)item{
    _item = item;
    self.textLabel.text = item.title;
    [self handleSelectedUI];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //设置选中的对勾  不设置的话 拖动cell时 会把editImageView的状态重置
    [self handleSelectedUI];
}

#pragma mark - private
    
- (void)handleSelectedUI{
    self.editImageView.image = [UIImage imageNamed:self.item.isSelected ? @"QT-012-2" : @"QT-012-3"];
    self.backgroundView.backgroundColor = self.item.isSelected ? [UIColor colorWithRed:1.0 green:100.0/255.0 blue:54.0/255.0 alpha:0.05] : [UIColor clearColor];
}
    
    //编辑状态下 勾选的imageView
- (UIImageView *)editImageView{
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews){
                if ([v isKindOfClass: [UIImageView class]]) {
                    return (UIImageView *)v;
                }
            }
        }
    }
    return nil;
}
    
#pragma mark - override
    
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
}
    
// 使用系统的cell的selected状态时 当刷新list[上拉加载 or 下拉刷新]时会重置selected状态 需要手动重新勾选 注释以下代码 ---> 使用数据model标记selected状态
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    //    if (self.isEditing) {
    //        self.editImageView.image = [UIImage imageNamed:selected ? @"QT-012-2" : @"QT-012-3"];
    //    }
}
    
//刷新list 时 editing状态会被重置  系统先调用cellforRow 再调用此方法 设置editing状态
- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    self.selectionStyle = editing ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
    [self handleSelectedUI];
}


@end
