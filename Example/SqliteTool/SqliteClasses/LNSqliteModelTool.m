//
//  LNSqliteModelTool.m
//  SqliteTool
//
//  Created by 宗丽娜 on 17/7/19.
//  Copyright © 2017年 nanaLxs. All rights reserved.
//

#import "LNSqliteModelTool.h"
#import "LNModelTool.h"
#import "LNSqliteTool.h"
#import "LNTableTool.h"
@implementation LNSqliteModelTool
+(BOOL)createTable:(Class)cls uid:(NSString *)uid{

    NSString * tabelName = [LNModelTool tableName:cls];
    
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        
        NSLog(@"如果想要操作这个模型, 必须要实现+ (NSString *)primaryKey;这个方法, 来告诉我主键信息");
        return NO;
    }
    NSString *primaryKey = [cls primaryKey];
    
    // 1.2 获取一个模型里面所有的字段, 以及类型
    
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(primary key(%@),%@)", tabelName,primaryKey, [LNModelTool columnNamesAndTypesStr:cls]];
    
    
    // 2. 执行
    return [LNSqliteTool deal:createTableSql uid:uid];

}

+(BOOL)isTableRequireUpdate:(Class)cls  uid:(NSString * )uid{
    NSArray * modelNames = [LNModelTool allTableSortedIvarNames:cls];
    NSArray * tableNames = [LNTableTool tabelSortedColumnNames:cls uid:uid];


    
    return ![modelNames isEqualToArray:tableNames];
}

+(BOOL)updateTable:(Class)cls uid:(NSString *)uid{

//1。创建一个拥有正确结构的临时表
    NSString * tmpTabelName = [LNModelTool tmpTableName:cls];
    //1.1 获取表格名称
     NSString *tableName = [LNModelTool tableName:cls];
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要操作这个模型, 必须要实现+ (NSString *)primaryKey;这个方法, 来告诉我主键信息");
        return NO;
    }
NSMutableArray *execSqls = [NSMutableArray array];
    
    //创建临时表
NSString *primaryKey = [cls primaryKey];
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@));", tmpTabelName, [LNModelTool columnNamesAndTypesStr:cls], primaryKey];
    
    [execSqls addObject:createTableSql];
    
    //2.根据主键，插入数据
    NSString * insertPrimaryKeyData = [NSString stringWithFormat:@"insert into %@(%@) select %@ from %@;",tmpTabelName,primaryKey,primaryKey,tableName];
    
       [execSqls addObject:insertPrimaryKeyData];
    
    
    // 3. 根据主键, 把所有的数据更新到新表里面
    NSArray *oldNames = [LNTableTool tabelSortedColumnNames:cls uid:uid];
    NSArray *newNames = [LNModelTool allTableSortedIvarNames:cls];
    
    for (NSString * columnName in newNames) {
        if (![oldNames containsObject:columnName]) {
            continue;
        }
        NSString * updateSql = [NSString stringWithFormat:@"update %@ set %@ = (select %@ from %@ where %@.%@ =%@.%@)",tmpTabelName, columnName, columnName, tableName, tmpTabelName, primaryKey, tableName, primaryKey];
         [execSqls addObject:updateSql];
    }
    
    
    NSString *deleteOldTable = [NSString stringWithFormat:@"drop table if exists %@", tableName];
    [execSqls addObject:deleteOldTable];
    
    NSString *renameTableName = [NSString stringWithFormat:@"alter table %@ rename to %@", tmpTabelName, tableName];
    
    [execSqls addObject:renameTableName];
    
    
    return [LNSqliteTool dealSqls:execSqls uid:nil];
}

@end
