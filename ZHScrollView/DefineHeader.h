//
//  DefineHeader.h
//  ZHTableView
//
//  Created by eastmoney on 2018/8/14.
//  Copyright © 2018年 EM. All rights reserved.
//

#ifndef DefineHeader_h
#define DefineHeader_h

#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define KNavHeight          (kDevice_Is_iPhoneX ? 88.0 : 64.0)
#define KtabBarHeight       (kDevice_Is_iPhoneX ? 83.0 : 49.0)
#define KStatusBarHeight    (kDevice_Is_iPhoneX ? 44.0 : 20.0)
#define KBottomMargin    (kDevice_Is_iPhoneX ? 34.0 : 0)
#define KScreenSize         ([[UIScreen mainScreen] bounds].size)

#define KScreenWidth        ([[UIScreen mainScreen] bounds].size.width)
#define KScreenHeight       ([[UIScreen mainScreen] bounds].size.height)


#endif /* DefineHeader_h */
