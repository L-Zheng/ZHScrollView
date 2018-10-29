//
//  BadgeIconView.h
//  ZHScrollView
//
//  Created by EM on 2018/10/29.
//  Copyright © 2018 EM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgeIconView : UIButton
@property (nonatomic, copy) NSString *badgeValue;
+ (instancetype)badgeView;
@end
