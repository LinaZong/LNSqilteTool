//
//  LNStu.h
//  SqliteTool
//
//  Created by 宗丽娜 on 17/7/19.
//  Copyright © 2017年 nanaLxs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNModelProtocol.h"
@interface LNStu : NSObject<LNModelProtocol>
{
    int b;
}
@property (nonatomic, assign) int stuNum;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;
@property (nonatomic, assign) float score;
@property (nonatomic, assign) float score2;
@end
