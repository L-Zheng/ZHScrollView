//
//  MultiTableLinkController.m
//  ZHTableView
//
//  Created by eastmoney on 2018/8/14.
//  Copyright © 2018年 EM. All rights reserved.
//

#import "MultiTableLinkController.h"
#import "MultiTableLinkFooterView.h"

@interface MultiTableLinkController ()

@property (nonatomic,strong) MultiTableLinkFooterView *footerView;
@property (nonatomic,assign) BOOL canScroll;

@end

@implementation MultiTableLinkController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.canScroll = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subTableViewDidScroll:) name:@"SubTableViewScrollNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subCollectionViewScroll) name:@"SubCollectionViewScrollNotification" object:nil];
    
    self.tableView.tableFooterView = self.footerView;
}

#pragma mark - getter

- (MultiTableLinkFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[MultiTableLinkFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [MultiTableLinkFooterView footerHeight])];
    }
    return _footerView;
}

#pragma mark - UITableViewDelegate
//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
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
    }
    cell.textLabel.text = [NSString stringWithFormat:@"--test--%ld行",indexPath.row];
    return cell;
}

//选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)limitY{
    return self.tableView.contentSize.height - self.footerView.bounds.size.height - 20;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //        if (self.tableView.ln_header.refreshing) {
    //            return;
    //        }
    BOOL canScroll = [self canScroll];
    CGPoint point = scrollView.contentOffset;
    
    if (!canScroll || point.y >= self.limitY) {
        [scrollView setContentOffset:CGPointMake(0, self.limitY)];
        self.tableView.showsVerticalScrollIndicator = NO;
    }else{
        self.tableView.showsVerticalScrollIndicator = YES;
    }
}

- (void)subTableViewDidScroll:(NSNotification *)note{
    UIScrollView *scrollView = note.userInfo[@"scrollView"];
    
    BOOL canScroll = [self canScroll];
    
    if (scrollView.contentOffset.y > 0) {
        //table上偏移
        
        if (canScroll && self.tableView.contentOffset.y < self.limitY) {
            [scrollView setContentOffset:CGPointZero];
            self.canScroll = YES;
            scrollView.showsVerticalScrollIndicator = NO;
        }else{
            //2、table上偏移  到达限制位置后继续上拉
            self.canScroll = NO;
            scrollView.showsVerticalScrollIndicator = YES;
        }
        
    }else{
        //下拉table
        self.canScroll = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        
        BOOL isRefresh = NO;
        if (isRefresh) {
            if (self.tableView.contentOffset.y > 0 && scrollView.contentOffset.y >= 0) {
                [scrollView setContentOffset:CGPointZero];
            }
        } else {
            [scrollView setContentOffset:CGPointZero];
        }
    }
}

- (void)subCollectionViewScroll{
    [self.tableView setContentOffset:CGPointMake(0, self.limitY) animated:YES];
    self.tableView.showsVerticalScrollIndicator = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.canScroll = NO;
    });
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
