//
//  SettingTableCell.h
//  ZHScrollView
//
//  Created by EM on 2018/10/29.
//  Copyright © 2018 EM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RowItem;

@interface SettingTableCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) RowItem *item;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
