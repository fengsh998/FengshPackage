//
//  FKDefines.h
//  FKUnitity
//
//  Created by fengsh on 16/3/9.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#ifndef FKDefines_h
#define FKDefines_h

#if __OBJC__
#  import <Foundation/Foundation.h>
#endif

/**
 * Make global functions usable in C++
 */
#if defined(__cplusplus)
#define FK_EXTERN extern "C" __attribute__((visibility("default")))
#else
#define FK_EXTERN extern __attribute__((visibility("default")))
#endif

#ifndef FK_DEBUG
#if DEBUG
#define FK_DEBUG 1
#else
#define FK_DEBUG 0
#endif
#endif

#ifndef FK_NSASSERT
#if FK_DEBUG
#define FK_NSASSERT 1
#else
#define FK_NSASSERT 0
#endif
#endif

#endif /* FKDefines_h */
