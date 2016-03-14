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
#import "FKNetworkRequest.h"

@implementation FKNetworking
{
    NSMutableDictionary<NSNumber *, FKNetworkTask *> *_tasksByRequestID;
    //key:handler类名 value:handler实例
    NSMutableDictionary<NSString*,id<FKURLRequestHandler>> *_handlers;
    //key:request类名 value:handler类
    NSMutableDictionary<NSString*, Class> *_handermodules;
}

//将请求类名和相应处理的handler类名进行邦定
- (void)bundingRequestClass:(Class)requestclass forRequestHandler:(Class)handler
{
    if (!_handermodules) {
        _handermodules = [NSMutableDictionary dictionary];
    }
    
    NSString *clsname = NSStringFromClass(requestclass);
    [_handermodules setObject:handler forKey:clsname];
}

- (void)unbundingRequestClass:(Class)requestclass
{
    NSString *clsname = NSStringFromClass(requestclass);
    if ([_handermodules objectForKey:clsname])
    {
        [_handermodules removeObjectForKey:clsname];
    }
}

- (void)removeAllBundings
{
    [_handermodules removeAllObjects];
}


- (id)moduleForClass:(Class)cls
{
    return [[cls alloc]init];
}

//过滤出需要当前请求需要使用的handler
//request 均为NSURLRequest的派生类即可
- (id<FKURLRequestHandler>)filterEffectHanderForRequest:(NSURLRequest *)request
{
    //获取类名
    NSString *currentRequestClassname = NSStringFromClass(request.class);
    
    //获取类名邦定的handler类名
    Class handlercls = [_handermodules objectForKey:currentRequestClassname];
    
    if (handlercls && [_handlers.allKeys containsObject:NSStringFromClass(handlercls)])
    {
        return [_handlers objectForKey:NSStringFromClass(handlercls)];
    }
    
    return nil;
}


- (id<FKURLRequestHandler>)handlerForRequest:(NSURLRequest *)request
{
    if (!request.URL) {
        return nil;
    }
    
    //控制只运行中只排序一次
    if (!_handlers) {
        
        // get handlers
        NSMutableDictionary<NSString*,id<FKURLRequestHandler>> *handlers = [NSMutableDictionary dictionary];
        
        // 添加handler
        for (Class handlerClass in [_handermodules allValues]) {
            NSString *key = NSStringFromClass(handlerClass);
            //不存在handler实例则创建
            if (![handlers.allKeys containsObject:key]) {
                id instance = [self moduleForClass:handlerClass];
                if (instance) {
                    [handlers setObject:instance forKey:key];
                }
            }
        }

        _handlers = handlers;
    }
    
    //取出request对应处理的handler
    id<FKURLRequestHandler> handler = [self filterEffectHanderForRequest:request];
    if (handler && [handler canHandleRequest:request]) {
        return handler;
    }
    
    return nil;
}


- (BOOL)canHandleRequest:(NSURLRequest *)request
{
    return [self handlerForRequest:request] != nil;
}


- (FKNetworkTask *)networkTaskWithRequest:(NSURLRequest *)request
                           completionBlock:(FKURLRequestCompletionBlock)completionBlock
{
    id<FKURLRequestHandler> handler = [self handlerForRequest:request];
    if (!handler) {
        FKLogError(@"No suitable URL request handler found for %@", request.URL);
        return nil;
    }
    
    return [[FKNetworkTask alloc] initWithRequest:request
                                           handler:handler
                                   completionBlock:completionBlock];
}


@end
