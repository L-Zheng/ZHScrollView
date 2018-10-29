//
//  BadgeIconView.m
//  ZHScrollView
//
//  Created by EM on 2018/10/29.
//  Copyright © 2018 EM. All rights reserved.
//

#import "BadgeIconView.h"

@implementation BadgeIconView

+ (instancetype)badgeView{
    BadgeIconView *view = [[BadgeIconView alloc] initWithFrame:CGRectMake(0, 0, 0, 15)];
    return view;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        [self setBackgroundColor:[UIColor redColor]];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = frame.size.height * 0.5;
    }
    return self;
}

- (void)setBadgeValue:(NSString *)badgeValue{
    _badgeValue = [badgeValue copy];
    [self setTitle:badgeValue forState:UIControlStateNormal];
    
    CGSize fitSize = [badgeValue boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
    
    CGRect frame = self.frame;
    frame.size.width = fitSize.width + 10;
    self.frame = frame;
}

@end
