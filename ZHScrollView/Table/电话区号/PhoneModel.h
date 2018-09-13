//
//  PhoneModel.h
//  ZHPickView
//
//  Created by eastmoney on 2017/7/20.
//  Copyright © 2017年 EM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneModel : NSObject

/** 英文 Hong Kong */
@property (nonatomic,copy) NSString *name;
/** 中文 香港 */
@property (nonatomic,copy) NSString *name_zh;
/** 电话区号 */
@property (nonatomic,copy) NSString *dial_code;
/** 国家英文代号 HK */
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *latin;

- (instancetype)initWithDic:(NSDictionary *)dic;

/** 获取拼音 */
+ (NSString *)getLatinize:(NSString *)str;

@end
