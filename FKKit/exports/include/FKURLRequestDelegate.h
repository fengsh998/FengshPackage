//
//  FKURLRequestDelegate.h
//  FKCore
//
//  Created by fengsh on 16/3/10.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#ifndef FKURLRequestDelegate_h
#define FKURLRequestDelegate_h

#import <Foundation/Foundation.h>

/**
    统一委托管理
 */
@protocol FKURLRequestDelegate <NSObject>

/**
 * 发送数据到服务器。如果数据大的时候会被调用多次。
 *
 */
- (void)URLRequest:(id)requestToken didSendDataWithProgress:(int64_t)bytesSent;

/**
 * 收到响应
 * 包括响应头
 */
- (void)URLRequest:(id)requestToken didReceiveResponse:(NSURLResponse *)response;

/**
 * 有数据收到就会被调用.
 *
 */
- (void)URLRequest:(id)requestToken didReceiveData:(NSData *)data;

/**
 * 请求发生错误
 *
 */
- (void)URLRequest:(id)requestToken didCompleteWithError:(NSError *)error;

@end

#endif /* FKURLRequestDelegate_h */
