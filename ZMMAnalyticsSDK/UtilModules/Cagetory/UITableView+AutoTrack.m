//
//  UITableView+AutoTrack.m
//  ZMMAnalyticsSDK
//
//  Created by 赵苗苗 on 2021/2/4.
//

#import "UITableView+AutoTrack.h"
#import "ZMMARuntime.h"
#import <objc/runtime.h>
#import "ZMMASchemeConfig.h"
#import "ZMMAnalyticsSDK.h"

static NSString *const swizzling_tableViewDidSelect = @"swizzling_tableViewDidSelectRowAtIndexPathWithDelegate:";

@implementation UITableView (AutoTrack)

+ (void)load {
    runTime.transforInstanceMethod_zmma([self class],@selector(setDelegate:),@selector(zmma__setDelegate:));
}

- (void)zmma__setDelegate:(id <UITableViewDelegate>)delegate
{
    [self zmma__setDelegate:delegate];
    if (delegate == nil) {
        return;
    }
#ifdef ZMMAMethodsExchange
    
    [self swizzling_tableViewDidSelectRowAtIndexPathWithDelegate:(id)delegate];
    
#endif
    
#ifdef  ZMMADynamicSubclass
    
#endif
    
}

#ifdef ZMMAMethodsExchange

- (void)swizzling_tableViewDidSelectRowAtIndexPathWithDelegate:(id)delegate
{
    //方法名
    SEL originalSel =  NSSelectorFromString(@"tableView:didSelectRowAtIndexPath:");
    //当代理对象没有实现didSelectRowAtIndexPath 直接返回
    if (![delegate respondsToSelector:originalSel]) {
        return;
    }
    //目的方法
    SEL destinationSel = NSSelectorFromString(swizzling_tableViewDidSelect);
    //当对象已经实现了本方法返回
    if ([delegate respondsToSelector:destinationSel]) {
        return;
    }
    IMP imp = class_getMethodImplementation([self class], @selector(swizzling_tableView:didSelectRowAtIndexPath:));
    //tableView对象添加方法
    runTime.classAddMethod_zmma([delegate class],destinationSel,imp);
    //交换方法
    runTime.transforInstanceMethod_zmma([delegate class],originalSel,destinationSel);
    
}
    

//  swizzle method IMP

- (void)swizzling_tableView:(UITableView * _Nullable)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nullable)indexPath
{
    SEL destinationsSelector = NSSelectorFromString(swizzling_tableViewDidSelect);
    if ([self respondsToSelector:destinationsSelector]) {
        // 调用父类
        IMP imp = [self methodForSelector:destinationsSelector];
        void (*objc_msgSend)(id, SEL,id,id) = (void *)imp;
        objc_msgSend(self, destinationsSelector,tableView,indexPath);
        [[ZMMAnalyticsSDK sharedInstance]trackAppClickWithTableView:tableView didSelectRowAtIndex_Path:indexPath properties:@{@"APPClick":@"UITableView"}];
    }
}


#endif

@end
