//
//  LNSqliteTool.m
//  SqliteDemo
//
//  Created by 宗丽娜 on 17/7/18.
//  Copyright © 2017年 nanaLxs. All rights reserved.
//

#import "LNSqliteTool.h"
#import "sqlite3.h"
//#define kCachePath  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject

#define kCachePath @"/Users/hi/Desktop/"

@interface LNSqliteTool()

@end


@implementation LNSqliteTool
//用户机制
//uid : nil  common.db
//uid:

sqlite3 * ppDb = nil;
+(BOOL)deal:(NSString *)sql uid:(NSString *) uid{
    
   
    // 打开数据库
    if (![self openDB:uid]) {
        NSLog(@"打开失败");
        return NO;
    }
    
    NSLog(@"SQL语句%@",sql);
    //create table if not exists XMGStu(age integer,b integer,stuNum integer,score real,name text, primary key(stuNum))
    // create table if not exists LNStu(primary key(stuNum),age integer,stuNum integer,score real,name text)
    BOOL result = sqlite3_exec(ppDb, sql.UTF8String, nil, nil, nil) == SQLITE_OK;
    
    NSLog(@"处理结果%d",result);
    
    // 3. 关闭数据库
    [self closeDB];
    
    return result;


}


+ (NSMutableArray  <NSMutableDictionary *>*)querySql:(NSString *)sql uid:(NSString *)uid{
  // 准备语句
    //1.创建准备语句
    // 参数1: 一个已经打开的数据库
    // 参数2: 需要中的sql
    // 参数3: 参数2取出多少字节的长度 -1 自动计算 \0
    // 参数4: 准备语句
    // 参数5: 通过参数3, 取出参数2的长度字节之后, 剩下的字符串
    
    sqlite3_stmt * ppStmt = nil;
    
    if( sqlite3_prepare_v2(ppDb, sql.UTF8String, -1, &ppStmt, nil) != SQLITE_OK){
    
        NSLog(@"准备语句编译失败");
        
        return nil;
    
    }
    //2.绑定数据
    
    
    //3执行
    //大数据
     NSMutableArray *rowDicArray = [NSMutableArray array];
    while (sqlite3_step(ppStmt) == SQLITE_ROW) {
        int columnCount = sqlite3_column_count(ppStmt);
        //一行记录 --》字典
        NSMutableDictionary *rowDic = [NSMutableDictionary dictionary];
        [rowDicArray addObject:rowDic];
        // 2. 遍历所有的列
        for (int i = 0; i < columnCount; i++) {
            // 2.1 获取列名
            const char *columnNameC = sqlite3_column_name(ppStmt, i);
            NSString *columnName = [NSString stringWithUTF8String:columnNameC];
            
            // 2.2 获取列值
            // 不同列的类型, 使用不同的函数, 进行获取
            // 2.2.1 获取列的类型
            int type = sqlite3_column_type(ppStmt, i);
            // 2.2.2 根据列的类型, 使用不同的函数, 进行获取
            id value = nil;
            switch (type) {
                case SQLITE_INTEGER:
                    value = @(sqlite3_column_int(ppStmt, i));
                    break;
                case SQLITE_FLOAT:
                    value = @(sqlite3_column_double(ppStmt, i));
                    break;
                case SQLITE_BLOB:
                    value = CFBridgingRelease(sqlite3_column_blob(ppStmt, i));
                    break;
                case SQLITE_NULL:
                    value = @"";
                    break;
                case SQLITE3_TEXT:
                    value = [NSString stringWithUTF8String: (const char *)sqlite3_column_text(ppStmt, i)];
                    break;
                    
                default:
                    break;
            }
            
            [rowDic setValue:value forKey:columnName];
            
        }

        
    }
    
    //4、重置（省略）

    //释放资源
    sqlite3_finalize(ppStmt);
    [self closeDB];
    
    return rowDicArray;

}

#pragma mark - 私有方法
+ (BOOL)openDB:(NSString *)uid {
    NSString *dbName = @"common.sqlite";
    if (uid.length != 0) {
        dbName = [NSString stringWithFormat:@"%@.sqlite", uid];
    }
    
    NSString *dbPath = [kCachePath stringByAppendingPathComponent:dbName];
    
    // 1. 创建&打开一个数据库
    
    return  sqlite3_open(dbPath.UTF8String, &ppDb) == SQLITE_OK;
    
}
+ (void)closeDB {
    
    sqlite3_close(ppDb);
}

+ (BOOL)dealSqls:(NSArray <NSString *>*)sqls uid:(NSString *)uid{
[self beginTransaction:uid];
    
    for (NSString *sql in sqls) {
        BOOL result = [self deal:sql uid:uid];
        if (result == NO) {
            [self rollBackTransaction:uid];
            return NO;
        }
    }
    
    [self commitTransaction:uid];
    return YES;

}

+ (void)beginTransaction:(NSString *)uid {
    [self deal:@"begin transaction" uid:uid];
}

+ (void)commitTransaction:(NSString *)uid {
    [self deal:@"commit transaction" uid:uid];
}
+ (void)rollBackTransaction:(NSString *)uid {
    [self deal:@"rollback transaction" uid:uid];
}


@end
