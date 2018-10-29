//
//  RowItem.h
//  ZHScrollView
//
//  Created by EM on 2018/10/29.
//  Copyright © 2018 EM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RowItem : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *badgeValue;
@property (nonatomic,copy) void (^selectedBlock) (NSIndexPath *indexPath, RowItem *item);

@end
