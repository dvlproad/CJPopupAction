//
//  UIView+CJSlideInterceptor.m
//  CJAnimationKit
//
//  Created by ciyouzen on 2026/7/31.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJSlideInterceptor.h"
#import "UIView+CJInterceptorChain.h"
#import <objc/runtime.h>

static NSMutableArray<CJSlideInterceptor> *_globalSlideInterceptors = nil;

@implementation UIView (CJSlideGlobalInterceptor)

+ (void)addSlideInterceptor:(CJSlideInterceptor)interceptor {
    if (!_globalSlideInterceptors) {
        _globalSlideInterceptors = [NSMutableArray array];
    }
    [_globalSlideInterceptors addObject:[interceptor copy]];
}

+ (void)removeSlideInterceptor:(CJSlideInterceptor)interceptor {
    [_globalSlideInterceptors removeObject:interceptor];
}

+ (void)removeAllSlideInterceptors {
    [_globalSlideInterceptors removeAllObjects];
}

+ (nullable NSArray<CJSlideInterceptor> *)cj_slideGlobalInterceptors {
    return _globalSlideInterceptors;
}

@end

@implementation UIView (CJSlideInstanceInterceptor)

- (NSArray<CJSlideInterceptor> *)slideInterceptors {
    return objc_getAssociatedObject(self, @selector(slideInterceptors));
}

- (void)setSlideInterceptors:(NSArray<CJSlideInterceptor> *)slideInterceptors {
    objc_setAssociatedObject(self, @selector(slideInterceptors), slideInterceptors, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)addInstanceSlideInterceptor:(CJSlideInterceptor)interceptor {
    NSMutableArray *interceptors = [NSMutableArray arrayWithArray:self.slideInterceptors ?: @[]];
    [interceptors addObject:[interceptor copy]];
    self.slideInterceptors = interceptors;
}

- (void)removeInstanceSlideInterceptor:(CJSlideInterceptor)interceptor {
    NSMutableArray *interceptors = [NSMutableArray arrayWithArray:self.slideInterceptors ?: @[]];
    [interceptors removeObject:interceptor];
    self.slideInterceptors = interceptors;
}

- (void)removeAllInstanceSlideInterceptors {
    self.slideInterceptors = @[];
}

@end
