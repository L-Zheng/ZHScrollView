//
//  MultiCollectionCell.m
//  ZHTableView
//
//  Created by eastmoney on 2018/8/14.
//  Copyright © 2018年 EM. All rights reserved.
//

#import "MultiCollectionCell.h"
#import "MultiLinkTableView.h"

@interface MultiCollectionCell ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) MultiLinkTableView *tableView;

@end

@implementation MultiCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.tableView];
        [self.tableView reloadData];
    }
    return self;
}

#pragma mark - getter

- (MultiLinkTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MultiLinkTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


#pragma mark - setter

- (void)setDataDic:(NSDictionary *)dataDic{
    
    if (_dataDic != dataDic) {
        _dataDic = dataDic;
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDelegate

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"--%@----test----%ld行",(self.dataDic ? self.dataDic[@"title"] : @"NULL"),indexPath.row];
    return cell;
}

//选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 滚动时发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubTableViewScrollNotification" object:nil userInfo:@{@"scrollView":scrollView}];
}

@end
