//
//  UINavigationItem+HideBackTitle.m
//  SPOS
//
//  Created by 张晓飞 on 16/4/26.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

#import "UINavigationItem+HideBackTitle.h"
#import <objc/runtime.h>

@implementation UINavigationItem (HideBackTitle)

/**
 *  load执行比较早，单例方法，方法替换。
 */
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originMethod = class_getInstanceMethod(self, @selector(backBarButtonItem));
        Method newMethod = class_getInstanceMethod(self, @selector(customBackBarButtonItem));
        if (class_addMethod(self, @selector(backBarButtonItem), method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
            class_replaceMethod(self, @selector(customBackBarButtonItem), method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        }else{
            method_exchangeImplementations(originMethod, newMethod);
        }
        
    });
}

//获取自定义UIBarButtonItem的backBarButton
static char kCustomBackBarButtonItemKey;
- (UIBarButtonItem *)customBackBarButtonItem {
    UIBarButtonItem * barButtonItem = [self customBackBarButtonItem];
    if (barButtonItem) {
        return barButtonItem;
    }
    barButtonItem = objc_getAssociatedObject(self, &kCustomBackBarButtonItemKey);
    if (!barButtonItem) {
        barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        objc_setAssociatedObject(self, &kCustomBackBarButtonItemKey, barButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return barButtonItem;
}

- (void)dealloc {
    objc_removeAssociatedObjects(self); //取消绑定的那些Object
}

@end
