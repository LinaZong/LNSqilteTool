//
//  LNModelProtocol.h
//  SqliteTool
//
//  Created by 宗丽娜 on 17/7/19.
//  Copyright © 2017年 nanaLxs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LNModelProtocol <NSObject>

@required
+ (NSString *)primaryKey;


@optional
+(NSArray * )ignoreColumnNames;
@end
