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
    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    if (originalMethod != NULL && swizzledMethod != NULL) {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

const struct ZMMARuntime runTime = {
    .transforInstanceMethod_zmma = transforInstanceMethod_zmma
};

@end
