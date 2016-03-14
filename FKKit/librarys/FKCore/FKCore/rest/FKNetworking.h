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
 *
 */
- (BOOL)canHandleRequest:(NSURLRequest *)request;

/**
 */
- (FKNetworkTask *)networkTaskWithRequest:(NSURLRequest *)request
                           completionBlock:(FKURLRequestCompletionBlock)completionBlock;

@end
