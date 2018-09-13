//
//  FolderTableController.m
//  ZHTableView
//
//  Created by eastmoney on 2018/9/5.
//  Copyright © 2018年 EM. All rights reserved.
//

#import "FolderTableController.h"
#import "FolderItem.h"

@interface FolderTableController ()
@property (nonatomic,retain) NSMutableArray <FolderItem *> *list;
@end

@implementation FolderTableController

- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma mark - getter

- (NSMutableArray <FolderItem *> *)list{
    if (!_list) {
        _list = [NSMutableArray array];
        for (NSInteger i = 0; i < 4; i++) {
            FolderItem *item = [[FolderItem alloc] init];
            item.subList = [NSMutableArray array];
            item.open = YES;
            for (NSInteger j = 0; j < 10; j++) {
                FolderSubItem *subItem = [[FolderSubItem alloc] init];
                [item.subList addObject:subItem];
            }
            [_list addObject:item];
        }
    }
    return _list;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list[section].isOpen ? self.list[section].subList.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"测试--组%ld--行%ld--",indexPath.section,indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"headerView"];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewClick:)];
        [headerView addGestureRecognizer:gesture];
    }
    headerView.tag = section;
    headerView.textLabel.text = [NSString stringWithFormat:@"组%ld",section];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0f;
}

#pragma mark - action

- (void)headerViewClick:(UITapGestureRecognizer *)tapGesture{
    UIView *headerView = tapGesture.view;
    self.list[headerView.tag].open = !self.list[headerView.tag].isOpen;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:headerView.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
}



@end
