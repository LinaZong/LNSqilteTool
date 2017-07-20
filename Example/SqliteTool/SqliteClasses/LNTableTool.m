//
//  LNTableTool.m
//  SqliteTool
//
//  Created by 宗丽娜 on 17/7/20.
//  Copyright © 2017年 nanaLxs. All rights reserved.
//

#import "LNTableTool.h"
#import "LNSqliteTool.h"
#import "LNModelTool.h"
@implementation LNTableTool
+(NSArray *)tabelSortedColumnNames:(Class)cls  uid:(NSString * )uid{

    NSString * tableName = [LNModelTool tableName:cls];
    
    NSString * queryCreateSqlStr = [NSString  stringWithFormat:@"select sql from sqlite_master where type = 'table' and name = '%@'",tableName];
    
    NSMutableDictionary * dic = [LNSqliteTool querySql:queryCreateSqlStr uid:uid].firstObject;
    
    NSString * createtableSql  = [dic[@"sql"] lowercaseString];
    NSString *createTableSql = [dic[@"sql"] lowercaseString];
    if (createTableSql.length == 0) {
        return nil;
    }
        createTableSql = [createTableSql stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
    createTableSql = [createTableSql stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    createTableSql = [createTableSql stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    createTableSql = [createTableSql stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSString *nameTypeStr = [createTableSql componentsSeparatedByString:@"("][1];
      NSArray *nameTypeArray = [nameTypeStr componentsSeparatedByString:@","];
    NSMutableArray * names = [NSMutableArray array];


    for (NSString  *  nameType in nameTypeArray) {
        
        if ([nameType  containsString:@"primary"]) {
            continue;
        }
    
        NSString *nameType2 = [nameType stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        
        
        // age integer
        NSString *name = [nameType2 componentsSeparatedByString:@" "].firstObject;
        
        [names addObject:name];
    
    }
    [names sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    return names;
}
@end
