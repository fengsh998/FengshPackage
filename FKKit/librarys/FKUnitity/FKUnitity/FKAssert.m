//
//  FKAssert.m
//  FKUnitity
//
//  Created by fengsh on 16/3/9.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import "FKAssert.h"

NSString *FKCurrentThreadName(void)
{
    NSThread *thread = [NSThread currentThread];
    NSString *threadName = thread.isMainThread ? @"main" : thread.name;
    if (threadName.length == 0) {
        const char *label = dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL);
        if (label && strlen(label) > 0) {
            threadName = @(label);
        } else {
            threadName = [NSString stringWithFormat:@"%p", thread];
        }
    }
    return threadName;
}
