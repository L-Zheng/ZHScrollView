//
//  SettingTableCell.m
//  ZHScrollView
//
//  Created by EM on 2018/10/29.
//  Copyright © 2018 EM. All rights reserved.
//

#import "SettingTableCell.h"
#import "BadgeIconView.h"
#import "RowItem.h"
#import "ArrowRowItem.h"
#import "SwitchRowItem.h"
#import "SubLabelRowItem.h"

@interface SettingTableCell ()
@property (strong, nonatomic) UIImageView *rightArrow;
@property (strong, nonatomic) UISwitch *rightSwitch;
@property (strong, nonatomic) UILabel *rightLabel;
@property (strong, nonatomic) BadgeIconView *bageView;
@end

@implementation SettingTableCell

#pragma mark - init

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"SettingTableCell";
    SettingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SettingTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont boldSystemFontOfSize:15];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.backgroundView = [[UIImageView alloc] init];
//        self.selectedBackgroundView = [[UIImageView alloc] init];
    }
    return self;
}


#pragma mark - getter

- (UIImageView *)rightArrow{
    if (_rightArrow == nil) {
        _rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_arrow"]];
    }
    return _rightArrow;
}

- (UISwitch *)rightSwitch{
    if (_rightSwitch == nil) {
        _rightSwitch = [[UISwitch alloc] init];
        [_rightSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _rightSwitch;
}

- (UILabel *)rightLabel{
    if (_rightLabel == nil) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textColor = [UIColor lightGrayColor];
        _rightLabel.font = [UIFont systemFontOfSize:13];
    }
    return _rightLabel;
}

- (BadgeIconView *)bageView{
    if (_bageView == nil) {
        _bageView = [BadgeIconView badgeView];
    }
    return _bageView;
}

#pragma mark - layout

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect frame = self.detailTextLabel.frame;
    frame.origin.x = CGRectGetMaxX(self.textLabel.frame) + 10;
    self.detailTextLabel.frame = frame;
}

#pragma mark - setter

- (void)setItem:(RowItem *)item{
    _item = item;

    self.imageView.image = [UIImage imageNamed:item.icon];
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.subtitle;
    
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    if (item.badgeValue) {
        
        self.bageView.badgeValue = item.badgeValue;
        self.accessoryView = self.bageView;
        
    } else if ([item isKindOfClass:[ArrowRowItem class]]) {//箭头
        
        self.accessoryView = self.rightArrow;
        
    } else if ([item isKindOfClass:[SwitchRowItem class]]) {//开关
        
        SwitchRowItem *switchItem = (SwitchRowItem *)item;
        self.rightSwitch.on = switchItem.isOn;
        self.accessoryView = self.rightSwitch;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else if ([item isKindOfClass:[SubLabelRowItem class]]) {//子标题
        
        SubLabelRowItem *labelItem = (SubLabelRowItem *)item;
        self.rightLabel.text = labelItem.text;
        CGSize fitSize = [labelItem.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.rightLabel.font} context:nil].size;
        self.rightLabel.frame = (CGRect){CGPointZero,fitSize};
        self.accessoryView = self.rightLabel;
        
    } else { // 取消右边的内容
        
        self.accessoryView = nil;
    }
}

#pragma mark - action

- (void)switchValueChanged:(UISwitch *)mySwitch{
    SwitchRowItem *switchItem = (SwitchRowItem *)self.item;
    switchItem.on = mySwitch.isOn;
    if (switchItem.switchBlock) {
        switchItem.switchBlock(self.indexPath, switchItem);
    }
}



@end
