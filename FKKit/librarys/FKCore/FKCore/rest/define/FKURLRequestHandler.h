//
//  FKURLRequestHandler.h
//  FKCore
//
//  Created by fengsh on 16/3/10.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#ifndef FKURLRequestHandler_h
#define FKURLRequestHandler_h

#import "FKURLRequestDelegate.h"

@protocol FKURLHandler <NSObject>

/**
    判断是否符合条件发起请求
 */
- (BOOL)canHandleRequest:(NSURLRequest *)request;

@optional

/**
 *  取消请求
 */
- (void)cancelRequest:(id)requestToken;

/**
 *  暂停请求
 */
- (void)suspendRequest:(id)requestToken;

/**
 *  恢复请求
 */

- (void)resumeRequest:(id)requestToken;

/**
 优先级，默认为0
 */
- (float)handlerPriority;


@end

/**
 */
@protocol FKURLRequestHandler <FKURLHandler>

- (id)sendRequest:(NSURLRequest *)request
     withDelegate:(id<FKURLRequestDelegate>)delegate;

@optional


- (id)sendRequest:(NSURLRequest *)request
withUploadFileUrl:(NSString *)fileurl
     withDelegate:(id<FKURLRequestDelegate>)delegate;

- (id)sendRequest:(NSURLRequest *)request
   withUploadData:(NSData *)data
     withDelegate:(id<FKURLRequestDelegate>)delegate;

@end


#endif /* FKURLRequestHandler_h */
