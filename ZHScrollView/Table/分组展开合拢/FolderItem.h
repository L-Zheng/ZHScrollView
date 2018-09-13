//
//  FolderItem.h
//  ZHTableView
//
//  Created by eastmoney on 2018/9/6.
//  Copyright © 2018年 EM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FolderSubItem : NSObject

@end

@interface FolderItem : NSObject
@property (nonatomic,assign,getter=isOpen) BOOL open;
@property (nonatomic,retain) NSMutableArray <FolderSubItem *> *subList;
@end
