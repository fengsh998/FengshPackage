//
//  FKLog.h
//  FKUnitity
//
//  Created by fengsh on 16/3/9.
//  Copyright © 2016年 fengsh. All rights reserved.
//
//                      console log output.
//

#import <Foundation/Foundation.h>

#import "FKDefines.h"

#ifndef FKLOG_ENABLED
#define FKLOG_ENABLED 1
#endif


/**
    外部宏使用
 */
#define FKLog(...)      _FKLog(FKLogLevelInfo, __VA_ARGS__)
#define FKLogTrace(...) _FKLog(FKLogLevelTrace, __VA_ARGS__)
#define FKLogInfo(...)  _FKLog(FKLogLevelInfo, __VA_ARGS__)
#define FKLogWarn(...)  _FKLog(FKLogLevelWarning, __VA_ARGS__)
#define FKLogError(...) _FKLog(FKLogLevelError, __VA_ARGS__)

/**
 *  日志输出级别
 */
typedef NS_ENUM(NSInteger, FKLogLevel) {
    FKLogLevelTrace         = 0,                //跟踪(级别较低)
    FKLogLevelInfo          = 1,                //按需信息输出
    FKLogLevelWarning       = 2,                //输出需要设为告警级别的日志
    FKLogLevelError         = 3,                //严重
    FKLogLevelFatal         = 4                 //至命
};

typedef void (^FKLogFunction)(
                               FKLogLevel level,
                               NSString *fileName,
                               NSNumber *lineNumber,
                               NSString *message
                               );


extern FKLogFunction FKDefaultLogFunction;
/**
    可外部指定输出
 */
FK_EXTERN void FKSetLogFunction(FKLogFunction logFunction);
FK_EXTERN FKLogFunction FKGetLogFunction();

/**
 * Private logging function - ignore this.
 */
#if FKLOG_ENABLED
#define _FKLog(lvl, ...) _FKLogInternal(lvl, __FILE__, __LINE__, __VA_ARGS__);
#else
#define _FKLog(lvl, ...) do { } while (0)
#endif

FK_EXTERN void _FKLogInternal(FKLogLevel, const char *, int, NSString *, ...) NS_FORMAT_FUNCTION(4,5);
