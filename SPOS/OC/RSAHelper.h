//
//  RSAHelper.h
//  SPOS
//
//  Created by 张晓飞 on 16/1/29.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSAHelper : NSObject

- (NSString *)rsaEncrypt:(NSString *)content keyPath:(NSString *)keyPath;
- (NSString *)rsaPEncrypt:(NSString *)content keyPath:(NSString *)keyPath;
- (NSString *)rsaDecrypt:(NSString *)content keyPath:(NSString *)keyPath;
- (NSString *)rsaPDecrypt:(NSString *)content keyPath:(NSString *)keyPath;
@end
