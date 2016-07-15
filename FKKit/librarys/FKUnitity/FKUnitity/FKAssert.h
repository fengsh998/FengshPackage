//
//  FKAssert.h
//  FKUnitity
//
//  Created by fengsh on 16/3/9.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FKDefines.h"

#ifndef NS_BLOCK_ASSERTIONS
#define FKAssert(condition, ...) do { \
if ((condition) == 0) { \
if (FK_NSASSERT) { \
[[NSAssertionHandler currentHandler] handleFailureInFunction:@(__func__) \
file:@(__FILE__) lineNumber:__LINE__ description:__VA_ARGS__]; \
} \
} \
} while (false)
#else
#define FKAssert(condition, ...) do {} while (false)
#endif


/**
 *  检测参数是否为非空或非0.
 */
#define FKAssertParam(name) FKAssert(name, @"'%s' is a required parameter", #name)

/**
 *  检测当前是否运行在主线程.
 */
#define FKAssertMainThread() FKAssert([NSThread isMainThread], \
@"This function must be called on the main thread")

/**
 *  检测当前运行不应该在主线程中运行.
 */
#define FKAssertNotMainThread() FKAssert(![NSThread isMainThread], \
@"This function must not be called on the main thread")

/**
 * 调试模式下获取当前线程名
 */
FK_EXTERN NSString *FKCurrentThreadName(void);

/**
    只用在调试模式
 */
#if DEBUG

#define FKAssertThread(thread, format...) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
FKAssert( \
[(id)thread isKindOfClass:[NSString class]] ? \
[FKCurrentThreadName() isEqualToString:(NSString *)thread] : \
[(id)thread isKindOfClass:[NSThread class]] ? \
[NSThread currentThread] ==  (NSThread *)thread : \
dispatch_get_current_queue() == (dispatch_queue_t)thread, \
format); \
_Pragma("clang diagnostic pop")

#else

#define FKAssertThread(thread, format...) do { } while (0)

#endif

