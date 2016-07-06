//
//  RSAHelper.m
//  SPOS
//
//  Created by 张晓飞 on 16/1/29.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

#import "RSAHelper.h"
#include<openssl/rsa.h>
#include<openssl/pem.h>
#import "HEXKit.h"

@implementation RSAHelper

- (NSString *)rsaEncrypt:(NSString *)content keyPath:(NSString *)keyPath
{
    int flen = (int)content.length;
    Byte * byteT = (Byte *)malloc(flen + 1);
    memset(byteT, '\0', flen + 1);
    Byte * byte = (Byte *)[[content dataUsingEncoding:NSUTF8StringEncoding] bytes];
    memccpy(byteT, byte, 0, flen);
    char *path_key = (char *)[keyPath cStringUsingEncoding:NSUTF8StringEncoding];
    printf("[%s] \n" ,byteT);
    RSA *p_rsa = RSA_new();
    FILE *file;
    if((file = fopen(path_key, "r")) == NULL){
        return NULL;
    }
    if(PEM_read_RSA_PUBKEY(file, &p_rsa, 0, 0)==NULL){
        return NULL;
    }
    unsigned char *p_en;
    int rsa_len=RSA_size(p_rsa);
    p_en=(unsigned char *)malloc(rsa_len + 1);
    memset(p_en,'\0',rsa_len + 1);
    int result = RSA_public_encrypt(flen , byteT , p_en , p_rsa , RSA_PKCS1_PADDING);
    if(result < 0){
        return NULL;
    }
    RSA_free(p_rsa);
    fclose(file);
    HEXKit *kit = [[HEXKit alloc] init];
    NSString *hexStr= [kit bytes2HexString:p_en len:result];
    NSLog(@"[%@]" , hexStr);
    return hexStr;
}
- (NSString *)rsaDecrypt:(NSString *)content keyPath:(NSString *)keyPath
{
    HEXKit *kit = [[HEXKit alloc] init];
    char *path_key = (char *)[keyPath cStringUsingEncoding:NSUTF8StringEncoding];
    Byte *byte = [kit hexString2Bytes:content];
    Byte *p_de;
    RSA *p_rsa;
    FILE *file;
    int rsa_len;
    if((file=fopen(path_key,"r"))==NULL){
        return NULL;
    }
    if((p_rsa=PEM_read_RSAPrivateKey(file,NULL,NULL,NULL))==NULL){
        return NULL;
    }
    rsa_len=RSA_size(p_rsa);
    p_de=(Byte *)malloc(rsa_len+1);
    memset(p_de , '\0' , rsa_len+1);
    int result = RSA_private_decrypt( rsa_len, byte , p_de , p_rsa , RSA_PKCS1_PADDING ) ;
    if(result < 0){
        return NULL;
    }
    RSA_free(p_rsa);
    fclose(file);
    return [[NSString alloc] initWithCString:(const char *)p_de encoding:NSUTF8StringEncoding];
}

- (NSString *)rsaPDecrypt:(NSString *)content keyPath:(NSString *)keyPath
{
    HEXKit *kit = [[HEXKit alloc] init];
    char *path_key = (char *)[keyPath cStringUsingEncoding:NSUTF8StringEncoding];
    Byte *byte = [kit hexString2Bytes:content];
    Byte *p_de;
    RSA *p_rsa = RSA_new();
    FILE *file;
    if((file = fopen(path_key, "r")) == NULL){
        return NULL;
    }
    if(PEM_read_RSA_PUBKEY(file, &p_rsa, 0, 0)==NULL){
        return NULL;
    }
    int rsa_len=RSA_size(p_rsa);
    p_de=(Byte *)malloc(rsa_len+1);
    memset(p_de , '\0' , rsa_len+1);
    int result = RSA_public_decrypt( rsa_len, byte , p_de , p_rsa , RSA_PKCS1_PADDING ) ;
    if(result < 0){
        return NULL;
    }
    RSA_free(p_rsa);
    fclose(file);
    return [[NSString alloc] initWithCString:(const char *)p_de encoding:NSUTF8StringEncoding];
}

- (NSString *)rsaPEncrypt:(NSString *)content keyPath:(NSString *)keyPath
{
    return nil;
}



@end
