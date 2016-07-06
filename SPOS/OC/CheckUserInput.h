//
//  CheckUserInput.h
//  SPOS
//
//  Created by 许佳强 on 16/5/9.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

#ifndef CheckUserInput_h
#define CheckUserInput_h

@interface CheckUserInput : NSObject

+ (BOOL) validateEmail:(NSString *)email;
+ (BOOL) validateMobile:(NSString *)mobile;
+ (BOOL) validateCarNo:(NSString *)carNo;
+ (BOOL) validateCarType:(NSString *)CarType;
+ (BOOL) validateUserName:(NSString *)name;
+ (BOOL) validatePassword:(NSString *)passWord;
+ (BOOL) validateNickname:(NSString *)nickname;
+ (BOOL) validateIdentityCard: (NSString *)identityCard;



@end

#endif /* CheckUserInput_h */
