//
//  SettingTableController.m
//  ZHScrollView
//
//  Created by EM on 2018/10/29.
//  Copyright © 2018 EM. All rights reserved.
//

#import "SettingTableController.h"
#import "GroupItem.h"
#import "RowItem.h"
#import "ArrowRowItem.h"
#import "SwitchRowItem.h"
#import "SubLabelRowItem.h"
#import "SettingTableCell.h"

@interface SettingTableController ()
@property (nonatomic, strong) NSMutableArray <GroupItem *> *groups;

@end

@implementation SettingTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self loadData];
    [self.tableView reloadData];
}

#pragma mark - data

- (void)loadData{
    GroupItem *group = [GroupItem group];
    group.header = @"组头0";
    group.footer = @"组尾0";
    
    RowItem *item1 = [[RowItem alloc] init];
    item1.icon = @"hot_status";
    item1.title = @"RowItem";
    item1.subtitle = @"subRowItem";
    item1.selectedBlock = ^(NSIndexPath *indexPath, RowItem *item) {
        NSLog(@"--组：%ld--行：%ld--标题：%@",indexPath.section,indexPath.row,item.title);
    };
    
    ArrowRowItem *item2 = [[ArrowRowItem alloc] init];
    item2.icon = @"find_people";
    item2.title = @"ArrowRowItem";
    item2.subtitle = @"subArrowRowItem";
    item2.selectedBlock = ^(NSIndexPath *indexPath, RowItem *item) {
        NSLog(@"--组：%ld--行：%ld--标题：%@",indexPath.section,indexPath.row,item.title);
    };
    
    ArrowRowItem *item5 = [[ArrowRowItem alloc] init];
    item5.icon = @"near";
    item5.title = @"ArrowRowItem";
    item5.subtitle = @"subArrowRowItem";
    item5.badgeValue = @"44";
    item5.selectedBlock = ^(NSIndexPath *indexPath, RowItem *item) {
        NSLog(@"--组：%ld--行：%ld--标题：%@",indexPath.section,indexPath.row,item.title);
    };
    
    SwitchRowItem *item3 = [[SwitchRowItem alloc] init];
    item3.icon = @"game_center";
    item3.title = @"SwitchRowItem";
    item3.subtitle = @"subSwitchRowItem";
    item3.selectedBlock = ^(NSIndexPath *indexPath, RowItem *item) {
        NSLog(@"--组：%ld--行：%ld--标题：%@",indexPath.section,indexPath.row,item.title);
    };
    item3.switchBlock = ^(NSIndexPath *indexPath, RowItem *item) {
        NSLog(@"-switch-组：%ld--行：%ld--标题：%@",indexPath.section,indexPath.row,item.title);
    };
    group.items = @[item1,item2,item5,item3];
    [self.groups addObject:group];
    

    GroupItem *group1 = [GroupItem group];
    group1.header = @"组头1";
    group1.footer = @"组尾1";
    SubLabelRowItem *item4 = [[SubLabelRowItem alloc] init];
    item4.icon = @"video";
    item4.title = @"SubLabelRowItem";
    item4.subtitle = @"subSubLabelRowItem";
    item4.text = @"啊";
    item4.selectedBlock = ^(NSIndexPath *indexPath, RowItem *item) {
        NSLog(@"--组：%ld--行：%ld--标题：%@",indexPath.section,indexPath.row,item.title);
    };
    group1.items = @[item4];
    [self.groups addObject:group1];
}

#pragma mark - getter

- (NSMutableArray <GroupItem *> *)groups{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groups[section].items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingTableCell *cell = [SettingTableCell cellWithTableView:tableView];
    cell.item = self.groups[indexPath.section].items[indexPath.row];
    cell.indexPath = indexPath;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] init];
    label.text = self.groups[section].header;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    return label;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] init];
    label.text = self.groups[section].footer;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!indexPath) return;
    
    RowItem *item = self.groups[indexPath.section].items[indexPath.row];

    //清空数字
    if (item.badgeValue) {
        item.badgeValue = nil;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    if (item.selectedBlock) {
        item.selectedBlock(indexPath, item);
    }
}


@end
