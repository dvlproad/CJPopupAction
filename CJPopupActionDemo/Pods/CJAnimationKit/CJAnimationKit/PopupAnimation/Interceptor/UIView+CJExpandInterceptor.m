//
//  UIView+CJExpandInterceptor.m
//  CJAnimationKit
//
//  Created by ciyouzen on 2026/7/31.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJExpandInterceptor.h"
#import "UIView+CJInterceptorChain.h"
#import <objc/runtime.h>

static NSMutableArray<CJExpandInterceptor> *_globalExpandInterceptors = nil;

@implementation UIView (CJExpandGlobalInterceptor)

+ (void)addExpandInterceptor:(CJExpandInterceptor)interceptor {
    if (!_globalExpandInterceptors) {
        _globalExpandInterceptors = [NSMutableArray array];
    }
    [_globalExpandInterceptors addObject:[interceptor copy]];
}

+ (void)removeExpandInterceptor:(CJExpandInterceptor)interceptor {
    [_globalExpandInterceptors removeObject:interceptor];
}

+ (void)removeAllExpandInterceptors {
    [_globalExpandInterceptors removeAllObjects];
}

+ (nullable NSArray<CJExpandInterceptor> *)cj_expandGlobalInterceptors {
    return _globalExpandInterceptors;
}

@end

@implementation UIView (CJExpandInstanceInterceptor)

- (NSArray<CJExpandInterceptor> *)expandInterceptors {
    return objc_getAssociatedObject(self, @selector(expandInterceptors));
}

- (void)setExpandInterceptors:(NSArray<CJExpandInterceptor> *)expandInterceptors {
    objc_setAssociatedObject(self, @selector(expandInterceptors), expandInterceptors, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)addInstanceExpandInterceptor:(CJExpandInterceptor)interceptor {
    NSMutableArray *interceptors = [NSMutableArray arrayWithArray:self.expandInterceptors ?: @[]];
    [interceptors addObject:[interceptor copy]];
    self.expandInterceptors = interceptors;
}

- (void)removeInstanceExpandInterceptor:(CJExpandInterceptor)interceptor {
    NSMutableArray *interceptors = [NSMutableArray arrayWithArray:self.expandInterceptors ?: @[]];
    [interceptors removeObject:interceptor];
    self.expandInterceptors = interceptors;
}

- (void)removeAllInstanceExpandInterceptors {
    self.expandInterceptors = @[];
}

@end
