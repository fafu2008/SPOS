//
//  HEXKit.m
//  SPOS
//
//  Created by 张晓飞 on 16/1/31.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

#import "HEXKit.h"

@implementation HEXKit

- (Byte *)hexString2Bytes:(NSString *)hexString
{
    Byte *myBuffer = (Byte *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (Byte)anInt;
    }
    return myBuffer;
}

- (NSString *)bytes2HexString:(Byte *)byte len:(int)len
{
    NSString *hexStr=@"";
    for(int i=0 ; i< len ; i++){
        NSString *newHexStr = [NSString stringWithFormat:@"%x",byte[i] & 0xFF];
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

@end
