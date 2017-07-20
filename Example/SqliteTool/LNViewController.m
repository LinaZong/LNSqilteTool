//
//  LNViewController.m
//  SqliteTool
//
//  Created by nanaLxs on 07/19/2017.
//  Copyright (c) 2017 nanaLxs. All rights reserved.
//

#import "LNViewController.h"
#import "LNSqliteModelTool.h"
@interface LNViewController ()

@end

@implementation LNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	  
    Class cls = NSClassFromString(@"LNStu");
    BOOL result = [LNSqliteModelTool createTable:cls uid:nil];
   
    NSLog(@"%d",result);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
