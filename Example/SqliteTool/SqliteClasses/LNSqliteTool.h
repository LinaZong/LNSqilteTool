//
//  LNSqliteTool.h
//  SqliteDemo
//
//  Created by 宗丽娜 on 17/7/18.
//  Copyright © 2017年 nanaLxs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNSqliteTool : NSObject


/* 创建/打开数据库处理 */
+(BOOL)deal:(NSString *)sql uid:(NSString *) uid;



/* 查询数据
 */
+ (NSMutableArray  <NSMutableDictionary *>*)querySql:(NSString *)sql uid:(NSString *)uid;



/*批量处理sql语句
 */
+ (BOOL)dealSqls:(NSArray <NSString *>*)sqls uid:(NSString *)uid;
@end
