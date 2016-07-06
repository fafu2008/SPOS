//
//  AESHelper.h
//  SPOS
//
//  Created by 张晓飞 on 16/1/31.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AESHelper : NSObject

- (NSString *)aes_encrypt:(NSString *)data key:(NSString*) key;
- (NSString *)aes_decrypt:(NSString *)data key:(NSString *) key;
- (NSString *)aes256_encrypt:(NSString *)key inData:(NSData *)inData;
- (NSString *)aes256_decrypt:(NSString *)key hexString:(NSString *)hexString;

@end
