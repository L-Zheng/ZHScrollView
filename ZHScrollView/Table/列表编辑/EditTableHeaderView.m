//
//  EditTableHeaderView.m
//  ZHTableView
//
//  Created by eastmoney on 2018/8/30.
//  Copyright © 2018年 EM. All rights reserved.
//

#import "EditTableHeaderView.h"

@interface EditTableHeaderView ()
@property (nonatomic,strong) UILabel *titleLab;/**< 标题 */
@end

@implementation EditTableHeaderView

#pragma mark - init
    
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
//        self.contentView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.titleLab];
    }
    return self;
}
    
#pragma mark - layout
    
- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLab.frame = self.bounds;
}
    
#pragma mark - public
    
- (void)updateTitle:(NSString *)title{
    self.titleLab.text = title;
}
    
#pragma mark - getter
    
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

@end
