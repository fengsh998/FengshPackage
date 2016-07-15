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

#import "FKHttpRequestHandler.h"
#import "FKUploadRequestHandler.h"

@interface FKNetworking()
{
    FKHttpRequestHandler                                    *_handler;
    
    FKUploadRequestHandler                                  *_uploadhandler;
    
}

@end

@implementation FKNetworking


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

- (FKNetworkTask *)networkTaskWithRequest:(NSURLRequest *)request
                           completionBlock:(FKURLRequestCompletionBlock)completionBlock
{
    if (!_handler) {
        _handler            = [[FKHttpRequestHandler alloc]init];
    }
    
    return [[FKNetworkTask alloc] initWithRequest:request
                                           handler:_handler
                                   completionBlock:completionBlock];
}

- (FKNetworkTask *)sendRequest:(NSURLRequest *)request
             withUploadFileUrl:(NSString *)fileurl
               completionBlock:(FKURLRequestCompletionBlock)completionBlock
{
    NSAssert(fileurl != nil, @"file path is NULL.");
    
    if (!_uploadhandler) {
        _uploadhandler      = [[FKUploadRequestHandler alloc]init];
    }
    
    FKNetworkUploadTask *task = [[FKNetworkUploadTask alloc] initWithRequest:request handler:_uploadhandler withFilepath:fileurl completionBlock:completionBlock];
    
    return task;
}

- (FKNetworkTask *)sendRequest:(NSURLRequest *)request
                withUploadData:(NSData *)data
               completionBlock:(FKURLRequestCompletionBlock)completionBlock
{
    if (!_uploadhandler) {
        _uploadhandler      = [[FKUploadRequestHandler alloc]init];
    }
    
    FKNetworkUploadTask *task = [[FKNetworkUploadTask alloc] initWithRequest:request handler:_uploadhandler withData:data completionBlock:completionBlock];
    
    return task;
}


@end
