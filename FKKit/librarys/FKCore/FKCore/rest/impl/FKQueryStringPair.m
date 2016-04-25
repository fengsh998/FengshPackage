//
//  FKQueryStringPair.m
//  FKCore
//
//  Created by fengsh on 16/4/25.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import "FKQueryStringPair.h"
#import "FKNetworkUnits.h"

@implementation FKQueryStringPair

- (id)initWithField:(id)field value:(id)value {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.field = field;
    self.value = value;
    
    return self;
}

- (NSString *)URLEncodedStringValue {
    if (!self.value || [self.value isEqual:[NSNull null]]) {
        return PercentEscapedStringFromString([self.field description]);
    } else {
        return [NSString stringWithFormat:@"%@=%@", PercentEscapedStringFromString([self.field description]), PercentEscapedStringFromString([self.value description])];
    }
}

@end
