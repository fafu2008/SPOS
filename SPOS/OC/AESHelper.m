//
//  AESHelper.m
//  SPOS
//
//  Created by 张晓飞 on 16/1/31.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

#import "AESHelper.h"
#import <CommonCrypto/CommonCrypto.h>
#import "HEXKit.h"
#include <openssl/aes.h>

@implementation AESHelper


//6a37e06a10bcd15562c893b8bd26aa30

- (NSString *)aes_encrypt:(NSString *)data key:(NSString*) key
{
    if(!data || !key) return nil;
    const char * k = [key cStringUsingEncoding:NSUTF8StringEncoding];
    AES_KEY aes;
    if(AES_set_encrypt_key((unsigned char*)k, (int)key.length * 8, &aes) < 0){
        return nil;
    }
    int padding = 0;
    int len=(int)data.length;
    if (len % AES_BLOCK_SIZE > 0) {
        padding = AES_BLOCK_SIZE - len % AES_BLOCK_SIZE ;
    }else{
        padding = 16;
    }
    len += padding;
    NSMutableString *ms = [[NSMutableString alloc] initWithString:data];
    NSMutableString *result = [[NSMutableString alloc] init];
    char filling = padding;
    while (padding > 0) {
        [ms appendFormat:@"%c" , filling];
        padding--;
    }
    for (int i = 0; i < len / AES_BLOCK_SIZE; i++) {
        NSString * inData = [ms substringWithRange:NSMakeRange(i * AES_BLOCK_SIZE, AES_BLOCK_SIZE)];
        unsigned char * outData = malloc(AES_BLOCK_SIZE);
        memset(outData, 0, AES_BLOCK_SIZE);
        AES_encrypt((const unsigned char *)[inData cStringUsingEncoding:NSUTF8StringEncoding], outData, &aes);
        HEXKit *kit = [[HEXKit alloc] init];
        NSString *outString = [kit bytes2HexString:outData len:AES_BLOCK_SIZE];
        [result appendString:outString];
        
    }
    return result;
}

- (NSString *)aes_decrypt:(NSString *)data key:(NSString *)key
{
    if (!data || !key) {
        return nil;
    }
    AES_KEY aes;
    if (AES_set_decrypt_key((const unsigned char *)[key cStringUsingEncoding:NSUTF8StringEncoding], (int)key.length * 8, &aes) < 0) {
        return nil;
    }
    int len = (int)data.length / 2;
    HEXKit *kit = [[HEXKit alloc] init];
    Byte * b = [kit hexString2Bytes:data];
    NSMutableString *ms = [[NSMutableString alloc] init];
    for (int i = 0; i < len/AES_BLOCK_SIZE; i++) {
        unsigned char * inData = malloc(AES_BLOCK_SIZE);
        memcpy(inData, b, AES_BLOCK_SIZE);
        unsigned char * tem = malloc(AES_BLOCK_SIZE);
        memset(tem, 0, AES_BLOCK_SIZE);
        AES_decrypt(inData, tem, &aes);
        NSString *outStr = [[NSString alloc] initWithBytes:tem length:AES_BLOCK_SIZE encoding:NSUTF8StringEncoding];
        [ms appendString:outStr];
    }
    return ms;
}


- (NSString *)aes256_encrypt:(NSString *)key inData:(NSData *)inData
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [inData length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL,
                                          [inData bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        HEXKit *kit = [[HEXKit alloc] init];
        return [kit bytes2HexString:(Byte *)[data bytes] len:(int)[data length]];
    }
    free(buffer);
    return nil;
}

- (NSString *)aes256_decrypt:(NSString *)key hexString:(NSString *)hexString
{
    HEXKit  *kit = [[HEXKit alloc] init];
    Byte *byte = [kit hexString2Bytes:hexString];
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = hexString.length/2;
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL,
                                          byte, dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
    }
    free(buffer);
    return nil;
}



@end
