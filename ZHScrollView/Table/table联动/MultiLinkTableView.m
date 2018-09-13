//
//  MultiLinkTableView.m
//  ZHTableView
//
//  Created by eastmoney on 2018/8/14.
//  Copyright © 2018年 EM. All rights reserved.
//

#import "MultiLinkTableView.h"

@implementation MultiLinkTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
