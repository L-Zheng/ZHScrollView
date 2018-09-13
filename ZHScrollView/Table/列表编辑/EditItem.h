//
//  EditItem.h
//  ZHTableView
//
//  Created by eastmoney on 2018/8/30.
//  Copyright © 2018年 EM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditItem : NSObject
    
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign,getter=isSelected) BOOL selected;

@end
