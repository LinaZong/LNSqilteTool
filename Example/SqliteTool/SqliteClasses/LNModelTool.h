//
//  LNModelTool.h
//  SqliteTool
//
//  Created by 宗丽娜 on 17/7/19.
//  Copyright © 2017年 nanaLxs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNModelTool : NSObject
//获取表名称
+(NSString *)tableName:(Class)cls;
//临时表名称
+(NSString *)tmpTableName:(Class)cls;
//所以的成员变量，以及成员变量对应的类型
+(NSDictionary *)classIvarNameTypeDic:(Class)cls;

// 所有的成员变量, 以及成员变量映射到数据库里面对应的类型
+(NSDictionary *)classIvarNameSqliteTypeDic:(Class)cls;

//所以的成员变量 拼接成字符串
+(NSString *)columnNamesAndTypesStr:(Class)cls;


//对所以的成员变量进行排序
+(NSArray *)allTableSortedIvarNames:(Class)cls;
@end
