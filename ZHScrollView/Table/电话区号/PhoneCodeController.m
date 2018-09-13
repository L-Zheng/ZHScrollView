//
//  PhoneCodeController.m
//  ZHTableView
//
//  Created by eastmoney on 2018/8/7.
//  Copyright © 2018年 EM. All rights reserved.
//

#import "PhoneCodeController.h"
#import "PhoneModel.h"

@interface PhoneCodeController ()

/* 数据结构
 @{
 @"A":@[phoneModel1,phoneModel2,phoneModel3],
 @"B":@[phoneModel1,phoneModel2,phoneModel3],
 }
 */
@property (nonatomic,retain) NSMutableDictionary *allModelsDic;
@property (nonatomic,retain) NSMutableArray *indexKeysArray;

@end

@implementation PhoneCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.sectionIndexColor = [UIColor orangeColor];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self handlePhoneData];
    });
}

#pragma mark - getter

- (NSMutableDictionary *)allModelsDic{
    if (!_allModelsDic) {
        _allModelsDic = [NSMutableDictionary dictionary];
    }
    return _allModelsDic;
}

- (NSMutableArray *)indexKeysArray{
    if (!_indexKeysArray) {
        _indexKeysArray = [NSMutableArray array];
    }
    return _indexKeysArray;
}

#pragma mark - data

- (void)handlePhoneData{
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"phoneCode" ofType:@"json"]];
    NSError *error = nil;
    NSArray *arrayCode = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return;
    }
    
    NSMutableDictionary *modelsDic = [NSMutableDictionary dictionary];
    for (NSDictionary *dic in arrayCode) {
        PhoneModel *phoneModel = [[PhoneModel alloc] initWithDic:dic];
        [modelsDic setObject:phoneModel forKey:phoneModel.code];
    }
    //获得时区和国家codeArray
    NSLocale *locale = [NSLocale currentLocale];
    NSArray *countryCodeArray = [NSLocale ISOCountryCodes];
    
    for (NSString *countryCode in countryCodeArray) {
        PhoneModel *phoneModel = [modelsDic objectForKey:countryCode];
        if (phoneModel) {
            phoneModel.name_zh = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
            if ([phoneModel.name_zh isEqualToString:@"台湾"]){
                phoneModel.name_zh = @"中国台湾";
            }
            phoneModel.latin = [PhoneModel getLatinize:phoneModel.name_zh];
        }else {
            NSLog(@"++ %@ %@",[locale displayNameForKey:NSLocaleCountryCode value:countryCode],countryCode);
        }
    }
    //归类
    for (PhoneModel *phoneModel in modelsDic.allValues) {
        NSString *indexKey = @"";
        if (phoneModel.latin.length > 0 ) {
            indexKey = [[phoneModel.latin substringToIndex:1] uppercaseString];
            char c = [indexKey characterAtIndex:0];
            if ((c < 'A') || (c > 'Z')){
                continue;
            }
        } else {
            continue;
        }
        NSMutableArray *indexValueArray = self.allModelsDic[indexKey];
        if (!indexValueArray) {
            indexValueArray = [NSMutableArray array];
            self.allModelsDic[indexKey] = indexValueArray;
        }
        [indexValueArray addObject:phoneModel];
    }
    //排序
    for (NSString *indexKey in self.allModelsDic.allKeys) {
        NSArray *indexValueArray = self.allModelsDic[indexKey];
        indexValueArray = [indexValueArray sortedArrayUsingComparator:^NSComparisonResult(PhoneModel *item_1, PhoneModel *item_2) {
            return [item_1.name_zh localizedStandardCompare:item_2.name_zh];
        }];
        self.allModelsDic[indexKey] = indexValueArray;
    }
    
    [self.indexKeysArray addObjectsFromArray:self.allModelsDic.allKeys];
    [self.indexKeysArray sortUsingSelector:@selector(caseInsensitiveCompare:)];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.indexKeysArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray <PhoneModel *> *phoneModelsArray = [self.allModelsDic valueForKey:self.indexKeysArray[section]];
    return phoneModelsArray.count;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexKeysArray;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"section"];
    UILabel *headerLabel = [headerView viewWithTag:100];
    if (!headerView) {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
        headerView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        
        headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 30, 30)];
        headerLabel.textAlignment = NSTextAlignmentLeft;
        headerLabel.textColor = [UIColor blackColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:14];
        headerLabel.tag = 100;
        [headerView addSubview:headerLabel];
    }
    headerLabel.text = self.indexKeysArray[section];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"PhoneTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    NSArray <PhoneModel *> *phoneModelsArray = [self.allModelsDic valueForKey:self.indexKeysArray[indexPath.section]];
    PhoneModel *phoneModel = phoneModelsArray[indexPath.row];
    
    cell.textLabel.text = phoneModel.name_zh;
    cell.detailTextLabel.text = phoneModel.dial_code;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray <PhoneModel *> *phoneModelsArray = [self.allModelsDic valueForKey:self.indexKeysArray[indexPath.section]];
    PhoneModel *phoneModel = phoneModelsArray[indexPath.row];
    NSLog(@"--%@--%@--",phoneModel.name_zh,phoneModel.dial_code);
}



@end
