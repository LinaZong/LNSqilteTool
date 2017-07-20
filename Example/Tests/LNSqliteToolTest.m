//
//  LNSqliteToolTest.m
//  SqliteTool
//
//  Created by 宗丽娜 on 17/7/19.
//  Copyright © 2017年 nanaLxs. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LNSqliteTool.h"
#import "LNSqliteModelTool.h"
@interface LNSqliteToolTest : XCTestCase

@end

@implementation LNSqliteToolTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    Class cls = NSClassFromString(@"LNStu");
    BOOL result = [LNSqliteModelTool createTable:cls uid:nil];
    XCTAssertEqual(result, YES);
}


- (void)testQuery {
    
    NSString *sql = @"select * from t_stu";
    NSMutableArray *result = [LNSqliteTool querySql:sql uid:nil];

    NSLog(@"%@", result);
    
    
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
