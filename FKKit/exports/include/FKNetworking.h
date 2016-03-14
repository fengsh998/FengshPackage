//
//  FKNetworking.h
//  FKCore
//
//  Created by fengsh on 16/3/10.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FKNetworkTask.h"

@interface FKNetworking : NSObject

- (void)bundingRequestClass:(Class)requestclass forRequestHandler:(Class)handler;
- (void)unbundingRequestClass:(Class)requestclass;
- (void)removeAllBundings;
/**
 * Does a handler exist for the specified request?
 */
- (BOOL)canHandleRequest:(NSURLRequest *)request;

/**
 * Return an RCTNetworkTask for the specified request. This is useful for
 * invoking the React Native networking stack from within native code.
 */
- (FKNetworkTask *)networkTaskWithRequest:(NSURLRequest *)request
                           completionBlock:(FKURLRequestCompletionBlock)completionBlock;

@end
