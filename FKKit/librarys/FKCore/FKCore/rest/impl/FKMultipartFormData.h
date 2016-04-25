//
//  FKMultipartFormData.h
//  FKCore
//
//  Created by fengsh on 16/4/22.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FKFormdataInterface <NSObject>

- (BOOL)appendPartWithFileURL:(NSURL * )fileURL
                         name:(NSString * )name
                        error:(NSError *  __autoreleasing *)error;

- (BOOL)appendPartWithFileURL:(NSURL *)fileURL
                         name:(NSString *)name
                     fileName:(NSString *)fileName
                     mimeType:(NSString *)mimeType
                        error:(NSError *  __autoreleasing *)error;

- (void)appendPartWithInputStream:(NSInputStream *)inputStream
                             name:(NSString *)name
                         fileName:(NSString *)fileName
                           length:(int64_t)length
                         mimeType:(NSString *)mimeType;


- (void)appendPartWithFileData:(NSData *)data
                          name:(NSString *)name
                      fileName:(NSString *)fileName
                      mimeType:(NSString *)mimeType;


- (void)appendPartWithFormData:(NSData *)data
                          name:(NSString *)name;



- (void)appendPartWithHeaders:(NSDictionary *)headers
                         body:(NSData *)body;


- (void)throttleBandwidthWithPacketSize:(NSUInteger)numberOfBytes
                                  delay:(NSTimeInterval)delay;


@end


static NSUInteger const kUploadStream3GSuggestedPacketSize = 1024 * 16;
static NSTimeInterval const kUploadStream3GSuggestedDelay = 0.2;

///form body part
@interface FKMultiBodyPart : NSObject
///MIME content-type
@property (nonatomic, assign)       NSStringEncoding stringEncoding;
///MIME headers
@property (nonatomic, strong)       NSDictionary *headers;
///分隔符
@property (nonatomic, copy)         NSString *boundary;
///body 体
@property (nonatomic, strong)       id body;
///body 长度
@property (nonatomic, assign)       unsigned long long bodyContentLength;
///输入流
@property (nonatomic, strong)       NSInputStream *inputStream;
///是否有分隔首节
@property (nonatomic, assign)       BOOL hasInitialBoundary;
///是否有分隔尾节
@property (nonatomic, assign)       BOOL hasFinalBoundary;

@property (readonly, nonatomic, assign, getter = hasBytesAvailable) BOOL bytesAvailable;
@property (readonly, nonatomic, assign) unsigned long long contentLength;

- (NSInteger)read:(uint8_t *)buffer
        maxLength:(NSUInteger)length;
@end

@interface FKMultipartBodyStream : NSInputStream <NSStreamDelegate>
@property (nonatomic, assign) NSUInteger numberOfBytesInPacket;
@property (nonatomic, assign) NSTimeInterval delay;
@property (nonatomic, strong) NSInputStream *inputStream;
@property (readonly, nonatomic, assign) unsigned long long contentLength;
@property (readonly, nonatomic, assign, getter = isEmpty) BOOL empty;

- (id)initWithStringEncoding:(NSStringEncoding)encoding;
- (void)setInitialAndFinalBoundaries;
- (void)appendHTTPBodyPart:(FKMultiBodyPart *)bodyPart;
@end


@interface FKMultipartFormData : NSObject<FKFormdataInterface>

- (instancetype)initWithURLRequest:(NSMutableURLRequest *)urlRequest
                    stringEncoding:(NSStringEncoding)encoding;

/**
 *  构造form 表单body 的请求
 *
 */
- (NSMutableURLRequest *)requestFromMultipartFormData;

@end
