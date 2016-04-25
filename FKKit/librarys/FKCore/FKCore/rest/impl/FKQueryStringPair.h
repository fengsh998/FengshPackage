//
//  FKQueryStringPair.h
//  FKCore
//
//  Created by fengsh on 16/4/25.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKQueryStringPair : NSObject
@property (readwrite, nonatomic, strong) id field;
@property (readwrite, nonatomic, strong) id value;

- (id)initWithField:(id)field value:(id)value;

- (NSString *)URLEncodedStringValue;
@end
