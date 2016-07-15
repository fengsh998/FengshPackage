//
//  FKNetworkingError.h
//  FKCore
//
//  Created by fengsh on 16/4/18.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const URLRequestErrorDomain;
extern NSString * const NetworkingOperationFailingURLRequestErrorKey;

extern NSString * const URLResponseErrorDomain;
extern NSString * const NetworkingOperationFailingURLResponseErrorKey;
extern NSString * const NetworkingOperationFailingURLResponseDataErrorKey;

@interface FKNetworkingError : NSObject

+ (NSError *)FKErrorWithUnderlyingError:(NSError *)error withUnderlyingError:(NSError *)underlyingError;
+ (BOOL)FKErrorOrUnderlyingErrorHasCodeInDomain:(NSError *)error withCode:(NSInteger) code withDomain:(NSString *)domain;
+ (id)JSONObjectByRemovingKeysWithNullValues:(id)JSONObject withJsonReadingOptions:(NSJSONReadingOptions) readingOptions;


@end
