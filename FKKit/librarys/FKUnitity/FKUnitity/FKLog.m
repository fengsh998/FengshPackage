//
//  FKLog.m
//  FKUnitity
//
//  Created by fengsh on 16/3/9.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import "FKLog.h"

#include <asl.h>
#import "FKAssert.h"

const char *FKLogLevels[] = {
    "trace",
    "info",
    "warn",
    "error",
    "fatal",
};

#if FK_DEBUG
static const FKLogLevel FKDefaultLogThreshold = FKLogLevelInfo - 1;
#else
static const FKLogLevel FKDefaultLogThreshold = FKLogLevelError;
#endif

static FKLogFunction FKCurrentLogFunction;
static FKLogLevel FKCurrentLogThreshold = FKDefaultLogThreshold;

/**
    设置日志输出阀值 setter getter
 */
void FKSetLogThreshold(FKLogLevel threshold) {
    FKCurrentLogThreshold = threshold;
}

FKLogLevel FKGetLogThreshold()
{
    return FKCurrentLogThreshold;
}

/**
    设置日志输出函数setter getter
 */
void FKSetLogFunction(FKLogFunction logFunction)
{
    FKCurrentLogFunction = logFunction;
}

FKLogFunction FKGetLogFunction()
{
    if (!FKCurrentLogFunction) {
        FKCurrentLogFunction = FKDefaultLogFunction;
    }
    return FKCurrentLogFunction;
}

NSString *FKFormatLog(
                       NSDate *timestamp,
                       FKLogLevel level,
                       NSString *fileName,
                       NSNumber *lineNumber,
                       NSString *message
                       )
{
    NSMutableString *log = [NSMutableString new];
    if (timestamp) {
        static NSDateFormatter *formatter;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            formatter = [NSDateFormatter new];
            formatter.dateFormat = formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS ";
        });
        [log appendString:[formatter stringFromDate:timestamp]];
    }
    if (level) {
        [log appendFormat:@"[%s]", FKLogLevels[level]];
    }
    
    [log appendFormat:@"[tid:%@]", FKCurrentThreadName()];
    
    if (fileName) {
        fileName = fileName.lastPathComponent;
        if (lineNumber) {
            [log appendFormat:@"[%@:%@]", fileName, lineNumber];
        } else {
            [log appendFormat:@"[%@]", fileName];
        }
    }
    if (message) {
        [log appendString:@" "];
        [log appendString:message];
    }
    return log;
}

/**
    默认日志输出函数
 */
FKLogFunction FKDefaultLogFunction = ^(
                                         FKLogLevel level,
                                         NSString *fileName,
                                         NSNumber *lineNumber,
                                         NSString *message
                                         )
{
    NSString *log = FKFormatLog([NSDate date], level, fileName, lineNumber, message);
    fprintf(stderr, "%s\n", log.UTF8String);
    fflush(stderr);
    
    int aslLevel;
    switch(level) {
        case FKLogLevelTrace:
            aslLevel = ASL_LEVEL_DEBUG;
            break;
        case FKLogLevelInfo:
            aslLevel = ASL_LEVEL_NOTICE;
            break;
        case FKLogLevelWarning:
            aslLevel = ASL_LEVEL_WARNING;
            break;
        case FKLogLevelError:
            aslLevel = ASL_LEVEL_ERR;
            break;
        case FKLogLevelFatal:
            aslLevel = ASL_LEVEL_CRIT;
            break;
    }
    asl_log(NULL, NULL, aslLevel, "%s", message.UTF8String);
};

void _FKLogInternal(FKLogLevel level, const char *fileName, int lineNumber, NSString *format, ...)
{
    FKLogFunction logFunction = FKGetLogFunction();
    BOOL log = FK_DEBUG || (logFunction != nil);
    if (log && level >= FKGetLogThreshold()) {
        // 获取参数
        va_list args;
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        
        // 输出
        if (logFunction) {
            logFunction(level, fileName ? @(fileName) : nil, lineNumber > 0 ? @(lineNumber) : nil, message);
        }
    }
}



