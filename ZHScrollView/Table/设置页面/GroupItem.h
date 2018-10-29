//
//  GroupItem.h
//  ZHScrollView
//
//  Created by EM on 2018/10/29.
//  Copyright © 2018 EM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RowItem;

@interface GroupItem : NSObject

@property (nonatomic, copy) NSString *header;
@property (nonatomic, copy) NSString *footer;
@property (nonatomic, strong) NSArray <RowItem *> *items;

+ (instancetype)group;

@end
