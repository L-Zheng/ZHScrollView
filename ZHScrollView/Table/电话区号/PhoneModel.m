//
//  PhoneModel.m
//  ZHPickView
//
//  Created by eastmoney on 2017/7/20.
//  Copyright © 2017年 EM. All rights reserved.
//

#import "PhoneModel.h"

@implementation PhoneModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        if (dic) {
            self.name = [dic valueForKey:@"name"];
            self.code = [dic valueForKey:@"code"];
            self.dial_code = [dic valueForKey:@"dial_code"];
        }
    }
    return self;
}


+ (NSString *)getLatinize:(NSString *)str{
    NSMutableString *source = [str mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformToLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    return source;
}

@end
