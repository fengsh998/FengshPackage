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

/**
 */
@protocol FKURLRequestHandler <NSObject>

/**
 */
- (BOOL)canHandleRequest:(NSURLRequest *)request;

/**
 */
- (id)sendRequest:(NSURLRequest *)request
     withDelegate:(id<FKURLRequestDelegate>)delegate;

@optional

- (void)cancelRequest:(id)requestToken;

/**
    优先级，默认为0
 */
- (float)handlerPriority;

@end

#endif /* FKURLRequestHandler_h */
