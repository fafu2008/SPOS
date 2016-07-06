//
//  HEXKit.h
//  SPOS
//
//  Created by 张晓飞 on 16/1/31.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HEXKit : NSObject

- (Byte *)hexString2Bytes:(NSString *)hexString;
- (NSString *)bytes2HexString:(Byte *)byte len:(int)len;

@end
