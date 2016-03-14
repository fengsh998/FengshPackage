//
//  FKNetworkingManager.h
//  FKCore
//
//  Created by fengsh on 16/3/14.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FKNetworkRequest.h"
#import "FKNetworkTask.h"
#import "FKNetworking.h"

@interface FKNetworkingManager : NSObject


+ (instancetype)defaultManager;

//设置请求serializer
//设置响应serializer
-(void)test;

@end
