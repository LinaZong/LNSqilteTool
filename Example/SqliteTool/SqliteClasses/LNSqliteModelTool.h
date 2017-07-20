//
//  LNSqliteModelTool.h
//  SqliteTool
//
//  Created by 宗丽娜 on 17/7/19.
//  Copyright © 2017年 nanaLxs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNModelProtocol.h"

@interface LNSqliteModelTool : NSObject

+(BOOL)createTable:(Class)cls  uid:(NSString *)uid;


//表是否需要更新
+(BOOL)isTableRequireUpdate:(Class)cls  uid:(NSString * )uid;

//表的升级迁移
+(BOOL)updateTable:(Class)cls uid:(NSString *)uid;
@end
