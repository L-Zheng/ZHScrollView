//
//  EditTableController.m
//  ZHTableView
//
//  Created by eastmoney on 2018/8/30.
//  Copyright © 2018年 EM. All rights reserved.
//

#import "EditTableController.h"
#import "EditTableHeaderView.h"
#import "EditItem.h"
#import "EditTableCell.h"
#import "EditBottomView.h"

@interface EditTableController ()
    @property (nonatomic,retain) NSMutableArray <NSMutableArray <EditItem *> *> *list;
@property (nonatomic, strong) EditBottomView *bottomView;
@property (nonatomic,assign) NSInteger selectedCount;
@end

@implementation EditTableController
    
- (void)viewDidLoad {
    [super viewDidLoad];    

    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.estimatedSectionHeaderHeight = 35.0;
    self.tableView.allowsSelectionDuringEditing = YES;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, KNavHeight - KStatusBarHeight)];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    [btn setTitle:@"完成" forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.view addSubview:self.bottomView];
}

#pragma mark - action

//编辑按钮action
- (void)editAction:(UIButton *)btn{
    btn.selected = !btn.isSelected;
    
    //取消编辑时 重置所有数据的选中状态
    if (self.tableView.isEditing) {
        [self batchEditAllData:NO];
    }
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
    //显示bottomView
    [UIView animateWithDuration:0.25 animations:^{
        BOOL isEdit = self.tableView.isEditing;
        
        isEdit ? [self.bottomView showView] : [self.bottomView hideView];
        CGRect frame = self.tableView.frame;
        frame.size.height = KScreenHeight - KNavHeight - KBottomMargin - (isEdit ? self.bottomView.bounds.size.height : 0);
        self.tableView.frame = frame;
    } completion:^(BOOL finished) {
        [self.tableView reloadData];
    }];
}
    
    //删除按钮action
- (void)deleteSelectedItem{
    if (self.selectedCount == 0) return;
    
    __weak typeof(self) weakSelf = self;
    //        [self deleteSelectedItemWithNoAnimation:^{
    //            [weakSelf.tableView reloadData];
    //        }];
    [self deleteSelectedItemWithDeleteRowsBlock:^(NSArray<NSIndexPath *> *indexPaths) {
        [weakSelf.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
    } deleteSectionsBlock:^(NSIndexSet *set) {
        [weakSelf.tableView deleteSections:set withRowAnimation:UITableViewRowAnimationRight];
    }];
    [weakSelf updateUIWhenDelete];
}

#pragma mark - UI

//删除
- (void)updateUIWhenDelete{
    [self updateBottomView];
    if (self.list.count == 0) {
        //全部删除  退出编辑状态
        [self editAction:self.navigationItem.rightBarButtonItem.customView];
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        //刷新  or  下拉刷新
        [self.tableView reloadData];
//        [self.tableView manualRefesh];
    }
}
    
//选中or取消选中  全部
- (void)updateUIWhenOperateAll:(BOOL)isSelected{
    [self batchEditAllData:isSelected];
    [self.tableView reloadData];
    [self updateBottomView];
}
    
//选中某一个
- (void)updateUIWhenSelectedSingle:(NSIndexPath *)indexPath{
    [self selecteOrCancelData:indexPath];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self updateBottomView];
}
    
//更新工具条
- (void)updateBottomView{
    [self.bottomView updateSelectedCount:self.selectedCount];
}
    
//删除
- (void)deleteSelectedItemWithNoAnimation:(void(^)(void))completion{
    if (self.selectedCount == 0) return;
    //本地数据删除
//    xxxxx
    //内存
    [self resetAllData];
//    [self handleData];//重新读取本地数据
    
    if (completion) {
        completion();
    }
}
    
- (void)deleteSelectedItemWithDeleteRowsBlock:(void(^)(NSArray <NSIndexPath *> *indexPaths))deleteRowsBlock deleteSectionsBlock:(void(^)(NSIndexSet *set))deleteSectionsBlock{
    if (self.selectedCount == 0) return;
    
    //等待删除操作的分组号
    NSMutableArray <NSNumber *> *oprateSectionArr = [NSMutableArray array];
    /**   数组内元素表示:  每一组内要删除的索引set
     @[<NSIndexSet *> obj1, <NSIndexSet *> obj2]
     */
    NSMutableArray <NSIndexSet *> *deleteSetArrAllSeciton = [NSMutableArray array];
    /** 数组内元素表示：  每一组内要删除的索引IndexPath array
     @[
     @[<NSIndexPath *> obj1, <NSIndexPath *> obj2],
     @[<NSIndexPath *> obj3, <NSIndexPath *> obj4]
     ]
     */
    NSMutableArray *deletePathArrayAllSection = [NSMutableArray array];
    
    for (NSInteger idx = 0; idx < self.list.count; idx++) {
        NSArray *subList = self.list[idx];
        //当前分组是否需要操作
        __block BOOL isNeedOperate = NO;
        //每一组内要删除的 元素 索引
        NSMutableIndexSet *deleteSetInSection = [NSMutableIndexSet indexSet];
        NSMutableArray *deletePathArrInSection = [NSMutableArray array];
        
        for (NSInteger subIdx = 0; subIdx < subList.count; subIdx++) {
            EditItem *item = subList[subIdx];
            if (!item.isSelected) continue;
            
            isNeedOperate = YES;
            [deleteSetInSection addIndex:subIdx];//保存index 用于删除内存array数据
            [deletePathArrInSection addObject:[NSIndexPath indexPathForItem:subIdx inSection:idx]];//保存indexPath  用于删除tableView列表
        }
        if (!isNeedOperate) continue;
        //保存
        [oprateSectionArr addObject:@(idx)];
        [deleteSetArrAllSeciton addObject:deleteSetInSection];
        [deletePathArrayAllSection addObject:deletePathArrInSection];
    }
    
    NSInteger count = oprateSectionArr.count;
    if (count == 0) return;
    
    //所有要删除的indexPath
    NSMutableArray *allDeleteIndexPaths = [NSMutableArray array];
    //所有要删除的分组集合set
    NSMutableIndexSet *deleteSectionSet = [NSMutableIndexSet indexSet];
    
    for (NSInteger i = 0; i < count; i++) {
        NSNumber *sectionNumber = oprateSectionArr[i];//当前组
        NSIndexSet *deleteSetInSection = deleteSetArrAllSeciton[i];//当前组内要删除的set集合
        NSArray <NSIndexPath *> *deletePathArrInSection = deletePathArrayAllSection[i];//当前组内要删除的indexPath array
        
        NSMutableArray *subList = self.list[sectionNumber.integerValue];
        
        //如果该组内的元素全部选中--->删除该组
        if (deletePathArrInSection.count == subList.count) {
            [deleteSectionSet addIndex:sectionNumber.integerValue];
        }
        //
        [subList removeObjectsAtIndexes:deleteSetInSection];
        //保存indexPath
        [allDeleteIndexPaths addObjectsFromArray:deletePathArrInSection];
    }
    //删除行
    if (allDeleteIndexPaths.count) {
        if (deleteRowsBlock) deleteRowsBlock(allDeleteIndexPaths);
    }
    
    //删除组
    if (deleteSectionSet.count) {
        [self.list removeObjectsAtIndexes:deleteSectionSet];
        if (deleteSectionsBlock) deleteSectionsBlock(deleteSectionSet);
    }
    
    self.selectedCount = 0;
}


#pragma mark - data
    
//选中所有数据 or 取消选中所有数据
- (void)batchEditAllData:(BOOL)isSelected{
    NSInteger count = 0;
    for (NSArray *subList in self.list) {
        for (EditItem *item in subList) {
            item.selected = isSelected;
            if (isSelected) {
                count++;
            }
        }
    }
    self.selectedCount = count;
}
    
//选中 or 取消选中 数据
- (void)selecteOrCancelData:(NSIndexPath *)indexPath{
    if (indexPath == nil || self.list.count <= indexPath.section) return;
    NSArray *subList = self.list[indexPath.section];
    
    if (subList.count <= indexPath.row) return;
    EditItem *item = subList[indexPath.row];
    item.selected = !item.isSelected;
    
    self.selectedCount += (item.selected ? 1 : -1);
}
    
//重置所有数据
- (void)resetAllData{
    self.list = nil;  //[self.list removeAllObjects]
    self.selectedCount = 0;
}
    
#pragma mark - getter
    
- (NSMutableArray <NSMutableArray <EditItem *> *> *)list{
    if (!_list) {
        _list = [NSMutableArray array];
        for (NSInteger i = 0; i < 4; i++) {
            NSMutableArray <EditItem *> *subList = [NSMutableArray array];
            for (NSInteger j = 0; j < 10; j++) {
                EditItem *item = [[EditItem alloc] init];
                item.title = [NSString stringWithFormat:@"测试--组%ld--行%ld--",i,j];
                item.selected = NO;
                [subList addObject:item];
            }
            [_list addObject:subList];
        }
    }
    return _list;
}
    
- (EditBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[EditBottomView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 49)];
        __weak typeof(self) weakSelf = self;
        _bottomView.selecteAllBlock = ^{
            [weakSelf updateUIWhenOperateAll:YES];
        };
        _bottomView.cancelBlock = ^{
            [weakSelf updateUIWhenOperateAll:NO];
        };
        _bottomView.deleteBlock = ^{
            [weakSelf deleteSelectedItem];
        };
    }
    return _bottomView;
}
    
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.list.count;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list[section].count;
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"EditTableCell";
    EditTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[EditTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.item = self.list[indexPath.section][indexPath.row];
    return cell;
}
    
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    EditTableHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    if (!headerView) {
        headerView = [[EditTableHeaderView alloc] initWithReuseIdentifier:@"headerView"];
    }
    [headerView updateTitle:[NSString stringWithFormat:@"组%ld",section]];
    return headerView;
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0f;
}

//Move
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//移动时调用
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    return proposedDestinationIndexPath;
}
//移动完成调用
//实现此方法 && tableView.edit=YES ---> tableView即可拖动
/** 拖动cell时如出现蓝色背景【蓝色背景会盖住contentView】---> 设置
 cell.multipleSelectionBackgroundView = [[UIView alloc]init];
 cell.multipleSelectionBackgroundView.backgroundColor = [UIColor clearColor];
 */
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    if (sourceIndexPath == destinationIndexPath) return;
    if ((sourceIndexPath.section == destinationIndexPath.section) && (sourceIndexPath.row == destinationIndexPath.row)) return;
    
    if (sourceIndexPath.section == destinationIndexPath.section){
        //同一组
        NSMutableArray <EditItem *> *subList = self.list[sourceIndexPath.section];
        EditItem *item = subList[sourceIndexPath.row];
        [subList removeObjectAtIndex:sourceIndexPath.row];
        [subList insertObject:item atIndex:destinationIndexPath.row];
    }else{
        NSMutableArray <EditItem *> *subList1 = self.list[sourceIndexPath.section];
        NSMutableArray <EditItem *> *subList2 = self.list[destinationIndexPath.section];
        
        EditItem *item = subList1[sourceIndexPath.row];
        [subList1 removeObjectAtIndex:sourceIndexPath.row];
        [subList2 insertObject:item atIndex:destinationIndexPath.row];
    }
}

//edit insert
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
    
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCellEditingStyleDelete  红点样式
//    UITableViewCellEditingStyleInsert  绿点加号样式
//    UITableViewCellEditingStyleNone    什么也没有样式
//    UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert 空白圆圈样式
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

// 只要实现该方法 && （editingStyleForRowAtIndexPath方法返回UITableViewCellEditingStyleDelete  or 实现editingStyleForRowAtIndexPath方法）, 手指在cell上面滑动的时候就自动实现了删除按钮
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        [self.list[indexPath.section] removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        
    }else if (UITableViewCellEditingStyleInsert == editingStyle){
        EditItem *item = [[EditItem alloc] init];
        item.title = @"临时插入";
        item.selected = NO;
        [self.list[indexPath.section] insertObject:item atIndex:indexPath.row + 1];

        NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationBottom];
    }
}

//手指左滑 删除的标题
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除啊啊啊";
}

//手指左滑自定义action  【实现该方法 左滑出现操作按钮】
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    //红色
    UITableViewRowAction *c1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    }];
    
    //默认  红色
    UITableViewRowAction *c2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"aa" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    c2.backgroundColor = [UIColor orangeColor];
    //    c2.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    //灰色
    UITableViewRowAction *c3 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"爱丽" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    }];
    return @[c1,c2,c3];
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (tableView.isEditing) {
        //编辑选中操作
        [self updateUIWhenSelectedSingle:indexPath];
    }else{
        //other
    }
}



@end
