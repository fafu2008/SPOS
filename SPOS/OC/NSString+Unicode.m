//
//  NSString+Unicode.m
//  SPOS
//
//  Created by 张晓飞 on 16/4/8.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

#import "NSString+Unicode.h"

@implementation NSString (Unicode)

//UTF8转Unicode
-(NSString *) utf8ToUnicode
{
    NSUInteger length = [self length];
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++){
        unichar _char = [self characterAtIndex:i];
        //判断是否为英文和数字
        if (_char <= '9' && _char >= '0'){
            [s appendFormat:@"%@",[self substringWithRange:NSMakeRange(i, 1)]];
        }else if(_char >= 'a' && _char <= 'z'){
            [s appendFormat:@"%@",[self substringWithRange:NSMakeRange(i, 1)]];
        }else if(_char >= 'A' && _char <= 'Z'){
            [s appendFormat:@"%@",[self substringWithRange:NSMakeRange(i, 1)]];
        }else{
            [s appendFormat:@"\\u%x",[self characterAtIndex:i]];
        }
        
    }
    return s;
    
}

@end
