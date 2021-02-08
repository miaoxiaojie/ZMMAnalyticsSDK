//
//  ZMMARuntime.m
//  ZMMAnalyticsSDK
//
//  Created by 赵苗苗 on 2021/2/4.
//

#import "ZMMARuntime.h"
#import <objc/runtime.h>

@implementation ZMMARuntime


/// 运行时互换函数调用顺序->实例方法
/// @param class 类
/// @param originalSelector 原始方法
/// @param swizzledSelector 交换方法
static void transforInstanceMethod_zmma(Class class, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    if (originalMethod != NULL && swizzledMethod != NULL) {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

static void classAddMethod_zmma(Class class, SEL destinationdeSel, IMP imp)
{
    Method sourceMethod = class_getInstanceMethod(class, destinationdeSel);
    const char * encoding = method_getTypeEncoding(sourceMethod);
    class_addMethod(class, destinationdeSel, imp, encoding);
    
}

const struct ZMMARuntime runTime = {
    .transforInstanceMethod_zmma = transforInstanceMethod_zmma,
    .classAddMethod_zmma = classAddMethod_zmma,
};

@end
