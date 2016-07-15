//
//  ViewController.m
//  FKKitTest
//
//  Created by fengsh on 16/3/9.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import "ViewController.h"

#import "FKUnitity.h"
#import "FKCore.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    NSString *ss = @"good running.";
//    NSArray *a = @[ss,@(38)];
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        FKLogInfo(@"%@",a);
//    });
//    
//    UITableView
    
    FKNetworkingManager *mgr = [FKNetworkingManager defaultManager];
    [mgr test];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
