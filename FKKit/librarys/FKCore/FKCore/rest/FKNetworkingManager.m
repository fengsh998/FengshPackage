//
//  FKNetworkingManager.m
//  FKCore
//
//  Created by fengsh on 16/3/14.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import "FKNetworkingManager.h"
#import "FKHttpRequestHandler.h"
#import "FKNetworkClient.h"


//test
#import "FKJsonRequestSettings.h"
#import "FKJsonResponseSettings.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "CommonFunc.h"
#import <CommonCrypto/CommonHMAC.h>
#import "FKHttpRequestSettings.h"

@interface FKNetworkingManager()
{
    FKNetworking                                    *_networking;
    
    FKNetworkClient                                 *_client;
}

@end

@implementation FKNetworkingManager

+ (instancetype)defaultManager
{
    static FKNetworkingManager *shareManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareManager = [[self alloc] init];
    });
    return shareManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self defaultConfig];
    }
    return self;
}

- (void)defaultConfig
{
   // _networking = [[FKNetworking alloc]init];
    //普能rest api
    //[_networking bundingRequestClass:[FKNetworkBase class] forRequestHandler:[FKHttpRequestHandler class]];
    
    _client = [[FKNetworkClient alloc]init];
    [_client setRequestSetting:[FKJsonRequestSettings defaultRequestSettings]];
    [_client setResponseSetting:[FKJsonResponseSettings defaultResponseSettings]];
}

+ (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key
{
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt)//传递过来的是decrypt 解码
    {
        //解码 base64
        NSData *decryptData = [CommonFunc dataWithBase64EncodedString:sText];//[GTMBase64 decodeString:sText];
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    }
    else  //encrypt
    {
        NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    NSData *keyData = [CommonFunc dataWithBase64EncodedString:key];//[GTMBase64 decodeString:key];
    /*
     DES加密 ：用CCCrypt函数加密一下，然后用base64编码下，传过去
     DES解密 ：把收到的数据根据base64，decode一下，然后再用CCCrypt函数解密，得到原本的数据
     */
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
    size_t dataOutAvailable = 0; //size_t  是操作符sizeof返回的结果类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
    NSString *initIv = @"12345678";
    const void *iv = (const void *) [initIv UTF8String];
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(encryptOperation,//  加密/解密
                       kCCAlgorithmDES,//  加密根据哪个标准（des，3des，aes。。。。）
                       kCCOptionECBMode|kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                       [keyData bytes],  //密钥    加密和解密的密钥必须一致
                       kCCKeySizeDES,//   DES 密钥的大小（kCCKeySizeDES=8）
                       iv, //  可选的初始矢量
                       dataIn, // 数据的存储单元
                       dataInLength,// 数据的大小
                       (void *)dataOut,// 用于返回数据
                       dataOutAvailable,
                       &dataOutMoved);
    
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt)//encryptOperation==1  解码
    {
        //得到解密出来的data数据，改变为utf-8的字符串
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding];
    }
    else //encryptOperation==0  （加密过程中，把加好密的数据转成base64的）
    {
        //编码 base64
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        result = [CommonFunc base64EncodedStringFrom:data];//[GTMBase64 stringByEncodingData:data];
    }
    free(dataOut);
    return result;
}

+ (NSString *)hmacSha1:(NSString*)key text:(NSString*)text
{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString *hash;
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", cHMAC[i]];
    hash = output;
    
    return hash;
}

-(void)test
{
    NSString *urls = @"https://passport.qbao.com/api/v34/getRandomCode";
    
    /*
     {
     password = "gnwzryrTQ+EwiVQj7bF7Lg==";
     signature = b7be9a38e5a4e26d4d6e4df374fe14b16c5b3365;
     username = 15927453382;
     }
     */
    
    
    
    FKNetworkTask *task = [_client requestPOSTUrlString:urls headers:nil withParams:nil completionBlock:^(NSURLResponse *response, id responseObj, NSError *error) {
        
        NSString *randomcode = responseObj[@"data"];
        
        NSString *encodePWD = [[self class]encrypt:@"fsh13870021792" encryptOrDecrypt:kCCEncrypt key:@"8raoJQeu09k="]; //[NSString encryptWithText:password];
        
        NSString *secString = [NSString stringWithFormat:@"%@(\"%@\"%@\"qbao\")",@"15927453382",@"*&Bl01o8",@"fsh13870021792"];

        NSString *hmacString = [[self class] hmacSha1:randomcode text:secString];
       
        NSDictionary *parmas = @{@"username":@"15927453382",@"password":encodePWD,@"signature":hmacString};
        
        
        /*
         {
         "Accept-Language" = "en-US;q=1";
         "Content-Type" = "application/x-www-form-urlencoded; charset=UTF-8";
         "Response-Content-Type" = "text/html";
         "User-Agent" = "qbaonew-ios/3.3.0";
         channel = "App Store";
         devId = "6EFE58EA-49CC-4A8F-B923-A47304ECDE7E";
         devType = iphone;
         sourceType = client;
         version = "3.3.0";
         }
         */
        
        FKHttpRequestSettings *a = [FKHttpRequestSettings defaultRequestSettings];
        [a setValue:@"App Store" forHTTPHeaderField:@"channel"];
        [a setValue:@"6EFE58EA-49CC-4A8F-B923-A47304ECDE7E" forHTTPHeaderField:@"devId"];
        [a setValue:@"iphone" forHTTPHeaderField:@"devType"];
        [a setValue:@"client" forHTTPHeaderField:@"sourceType"];
        [a setValue:@"3.3.0" forHTTPHeaderField:@"version"];
        //只认这个user agent
        [a setValue:@"qbaonew-ios/3.3.0" forHTTPHeaderField:@"User-Agent"];
        
        [_client setRequestSetting:a];
        
        FKNetworkTask *task11 = [_client requestPOSTUrlString:@"https://passport.qbao.com/api/v34/cas/tickets" headers:nil withParams:parmas completionBlock:^(NSURLResponse *response, id responseObj, NSError *error) {
            NSLog(@"response = %@ , obj = %@ error = %@",response,responseObj,error);
        }];
        
        [task11 start];
        
        NSLog(@"request %@ ,headers = %@",task11.request,task11.request.allHTTPHeaderFields);
    }];
    
    
    
    [task start];
    
    
    
    [self testUpload];
}

- (void)testUpload
{
    FKNetworkTask *utask = [_client requestHEADUrlString:@"http://www.freeimagehosting.net/upload.php" headers:@{@"Content-Type":@"image/jpeg",@"Accept":@"text/html"} withParams:nil method:@"POST" withFilepath:@"/Users/fengsh/Downloads/IMG_0446.JPG"/*@"/Users/fengsh/Desktop/big.jpg"*/ completionBlock:^(NSURLResponse *response, id responseObj, NSError *error) {
        NSLog(@"robj = %@",responseObj);
    }];
    
    [utask setUploadProgressBlock:^(int64_t progress, int64_t total){
        NSLog(@"progress = %lld,total = %lld",progress,total);
    }];
    
    [utask start];
    
    //暂停不了为啥呢？
    
    [utask suspend];
    
    [self performSelector:@selector(ontest:) withObject:utask afterDelay:10];
}

- (void)ontest:(FKNetworkTask *)utask
{
    //[utask resume];
}

@end
