//
//  LNStu.m
//  SqliteTool
//
//  Created by 宗丽娜 on 17/7/19.
//  Copyright © 2017年 nanaLxs. All rights reserved.
//

#import "LNStu.h"

@implementation LNStu

+ (NSString *)primaryKey {
    return @"stuNum";
}

+ (NSArray *)ignoreColumnNames {
    return @[@"b", @"score2"];
}
@end
