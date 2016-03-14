//
//  FKResopnseSerialization.h
//  FKCore
//
//  Created by fengsh on 16/3/14.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FKResopnseSerialization <NSObject, NSSecureCoding, NSCopying>

- (id)responseObjectForResponse:(NSURLResponse *)response
                                    data:(NSData *)data
                                   error:(NSError **)error;

@end


@interface FKResopnseSerializer : NSObject<FKResopnseSerialization>

@property (nonatomic, assign) NSStringEncoding stringEncoding;

/**
    See http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
*/
@property (nonatomic, copy) NSIndexSet *acceptableStatusCodes;

/**
 
 */
@property (nonatomic, copy) NSSet *acceptableContentTypes;

/**
    如果响应有效return YES ,否则NO
 */
- (BOOL)validateResponse:( NSHTTPURLResponse *)response
                    data:( NSData *)data
                   error:(NSError * *)error;
@end
