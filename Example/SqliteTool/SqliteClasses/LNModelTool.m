//
//  LNModelTool.m
//  SqliteTool
//
//  Created by 宗丽娜 on 17/7/19.
//  Copyright © 2017年 nanaLxs. All rights reserved.
//

#import "LNModelTool.h"
#import <objc/runtime.h>
#import "LNStu.h"
@implementation LNModelTool

+(NSString *)tableName:(Class)cls{
    
    return NSStringFromClass(cls);
    
}
+(NSString *)tmpTableName:(Class)cls{

    return  [NSStringFromClass(cls) stringByAppendingString:@"_tmp"];

}



+(NSDictionary *)classIvarNameTypeDic:(Class)cls{

    unsigned int outCount = 0;
    Ivar * varList = class_copyIvarList(cls, &outCount);
      NSMutableDictionary *nameTypeDic = [NSMutableDictionary dictionary];

    NSArray * ignoreNames = nil;
    
    if ([cls respondsToSelector:@selector(ignoreColumnNames)]) {
        ignoreNames = [cls ignoreColumnNames];
    }
    
    
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = varList[i];
        
        //1.获取成员变量名称
        NSString * ivarName = [NSString  stringWithUTF8String:ivar_getName(ivar)];
        if ([ivarName hasPrefix:@"_"]) {
            ivarName = [ivarName substringFromIndex:1];
        }
        
        //添加忽略
        if ([ignoreNames containsObject:ivarName]) {
            continue;
        }
        
        
        // 2. 获取成员变量类型
        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        
        type = [type stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];
        
        
        [nameTypeDic setValue:type forKey:ivarName];

        
    }
    
     return nameTypeDic;
}

+(NSDictionary *)classIvarNameSqliteTypeDic:(Class)cls{

    NSMutableDictionary * dic = [[self classIvarNameTypeDic:cls] mutableCopy];
    NSDictionary *typeDic = [self ocTypeToSqliteTypeDic];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * obj, BOOL * _Nonnull stop) {
        
        dic[key] = typeDic[obj];
    }];
    
    return dic;
 

}

+(NSString *)columnNamesAndTypesStr:(Class)cls{
    
    NSDictionary * nameTypeDic = [self classIvarNameSqliteTypeDic:cls];
    NSMutableArray *result = [NSMutableArray array];
    
    [nameTypeDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        
        [result addObject:[NSString stringWithFormat:@"%@ %@", key, obj]];
    }];
    
    
    return [result componentsJoinedByString:@","];

}

#pragma mark - 私有方法
+ (NSDictionary *)ocTypeToSqliteTypeDic {
    
    return @{
             @"d": @"real", // double
             @"f": @"real", // float
             
             @"i": @"integer",  // int
             @"q": @"integer", // long
             @"Q": @"integer", // long long
             @"B": @"integer", // bool
             
             @"NSData": @"blob",
             @"NSDictionary": @"text",
             @"NSMutableDictionary": @"text",
             @"NSArray": @"text",
             @"NSMutableArray": @"text",
             
             @"NSString": @"text"
             };
    
}


+(NSArray *)allTableSortedIvarNames:(Class)cls{

    NSDictionary * dic = [self classIvarNameTypeDic:cls];
    NSArray * keys = dic.allKeys;
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];

    return keys;
}











@end
