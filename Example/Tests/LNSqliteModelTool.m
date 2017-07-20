//
//  LNSqliteModelTool.m
//  SqliteTool
//
//  Created by 宗丽娜 on 17/7/19.
//  Copyright © 2017年 nanaLxs. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LNModelTool.h"
#import "LNStu.h"
@interface LNSqliteModelTool : XCTestCase

@end

@implementation LNSqliteModelTool

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
}

- (void)testIvarNameType {
    
    NSString *dic = [LNModelTool columnNamesAndTypesStr:[LNStu class]];
    NSLog(@"%@", dic);
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
