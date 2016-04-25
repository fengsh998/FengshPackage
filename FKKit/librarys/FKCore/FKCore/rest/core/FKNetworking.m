//
//  FKNetworking.m
//  FKCore
//
//  Created by fengsh on 16/3/10.
//  Copyright © 2016年 fengsh. All rights reserved.
//
//              在一个Networking的实例中，运行保证每个hander只存在一个实列
/*
    使用前记得将NSURLReqeust或其派生类和对应的handler进行邦定
    bundingRequestClass:forRequestHandler
 */

#import "FKNetworking.h"
#import "FKLog.h"
#import "FKNetworkUnits.h"
#import "FKHttpRequestHandler.h"

@interface FKNetworking()
{
    FKHttpRequestHandler                                    *_handler;
}

@end

@implementation FKNetworking


- (instancetype)init
{
    self = [super init];
    if (self) {
        _handler = [[FKHttpRequestHandler alloc]init];
    }
    return self;
}

- (FKNetworkTask *)networkTaskWithRequest:(NSURLRequest *)request
                           completionBlock:(FKURLRequestCompletionBlock)completionBlock
{
    
    return [[FKNetworkTask alloc] initWithRequest:request
                                           handler:_handler
                                   completionBlock:completionBlock];
}



@end
