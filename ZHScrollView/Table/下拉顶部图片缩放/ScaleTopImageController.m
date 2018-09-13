
//
//  ScaleTopImageController.m
//  ZHTableView
//
//  Created by eastmoney on 2018/9/6.
//  Copyright © 2018年 EM. All rights reserved.
//

#import "ScaleTopImageController.h"

#define BGImageViewW KScreenWidth
#define BGImageViewH BGImageViewW
#define BGInsetTop (BGImageViewH * 0.5)

@interface ScaleTopImageController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView *bgImageView;

@end

@implementation ScaleTopImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(BGInsetTop, 0, 0, 0);
    
    [self.tableView insertSubview:self.bgImageView atIndex:0];
    [self.tableView setContentOffset:CGPointMake(0, -BGInsetTop)];
}

#pragma mark - getter

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -BGImageViewH, BGImageViewW, BGImageViewH)];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.clipsToBounds = YES;
        _bgImageView.image = [UIImage imageNamed:@"folder"];
    }
    return _bgImageView;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
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
    cell.textLabel.text = @"test";
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 计算往下拽的距离
    CGFloat dragDelta = - BGInsetTop - scrollView.contentOffset.y;
    if (dragDelta < 0) dragDelta = 0;
    
    CGRect bgImageViewFrame = self.bgImageView.frame;
    bgImageViewFrame.size.height = BGImageViewH + dragDelta;
    bgImageViewFrame.origin.y = -bgImageViewFrame.size.height;
    self.bgImageView.frame = bgImageViewFrame;
}


@end
