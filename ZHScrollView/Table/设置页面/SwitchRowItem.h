//
//  SwitchRowItem.h
//  ZHScrollView
//
//  Created by EM on 2018/10/29.
//  Copyright © 2018 EM. All rights reserved.
//

#import "RowItem.h"

@interface SwitchRowItem : RowItem
@property (nonatomic,assign,getter=isOn) BOOL on;
@property (nonatomic,copy) void (^switchBlock) (NSIndexPath *indexPath, RowItem *item);
@end
