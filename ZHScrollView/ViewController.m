//
//  ViewController.m
//  ZHTableView
//
//  Created by eastmoney on 2018/8/7.
//  Copyright © 2018年 EM. All rights reserved.
//

#import "ViewController.h"
#import "PhoneCodeController.h"
#import "MultiTableLinkController.h"
#import "EditTableController.h"
#import "FolderTableController.h"
#import "ScaleTopImageController.h"
#import "DemoCollecitonController.h"
#import "CarouselCollectionController.h"
#import "WaterFallController.h"
#import "ScaleTranslateController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,retain) NSMutableArray <NSArray *> *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    self.title = @"table&&collection";
    
    [self.view addSubview:self.tableView];
}

#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [UIView new];
        
        _tableView.allowsSelectionDuringEditing = YES;
    }
    return _tableView;
}

- (NSMutableArray <NSArray *> *)dataArray{
    if (!_dataArray) {
        NSArray *data = @[
                          @[
                              @{
                                  @"title" : @"电话区号选择",
                                  @"block" : ^UIViewController *{
                                      return [[PhoneCodeController alloc] init];
                                  }
                                  },
                              @{
                                  @"title" : @"多个table联动",
                                  @"block" : ^UIViewController *{
                                      return [[MultiTableLinkController alloc] init];
                                  }
                                  },
                              @{
                                  @"title" : @"多选 删除 插入 排序",
                                  @"block" : ^UIViewController *{
                                      return [[EditTableController alloc] init];
                                  }
                                  },
                              @{
                                  @"title" : @"分组展开合拢",
                                  @"block" : ^UIViewController *{
                                      return [[FolderTableController alloc] init];
                                  }
                                  },
                              @{
                                  @"title" : @"下拉顶部图片放大",
                                  @"block" : ^UIViewController *{
                                      return [[ScaleTopImageController alloc] init];
                                  }
                                  }
                              ],
                          @[
                              @{
                                  @"title" : @"collection示例",
                                  @"block" : ^UIViewController *{
                                      return [[DemoCollecitonController alloc] init];
                                  }
                                  },
                              @{
                                  @"title" : @"轮播图",
                                  @"block" : ^UIViewController *{
                                      return [[CarouselCollectionController alloc] init];
                                  }
                                  },
                              @{
                                  @"title" : @"瀑布流",
                                  @"block" : ^UIViewController *{
                                      return [[WaterFallController alloc] init];
                                  }
                                  },
                              @{
                                  @"title" : @"缩放平移",
                                  @"block" : ^UIViewController *{
                                      return [[ScaleTranslateController alloc] init];
                                  }
                                  }
                              ]
                          ];
        _dataArray = [NSMutableArray arrayWithArray:data];
    }
    return _dataArray;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray[section].count;
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
    cell.textLabel.text = [self.dataArray[indexPath.section][indexPath.row] valueForKey:@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //    NSString *selectorStr = [self.dataArray[indexPath.row] valueForKey:@"action"];
    NSDictionary *dic = self.dataArray[indexPath.section][indexPath.row];
    UIViewController * (^block) (void) = [dic valueForKey:@"block"];
    NSString *title = [dic valueForKey:@"title"];
    if (block) {
        UIViewController *vc = block();
        vc.title = title;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    //#pragma clang diagnostic push
    //#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    //    [self performSelector:NSSelectorFromString(selectorStr)];
    //#pragma clang diagnostic push
}



@end
