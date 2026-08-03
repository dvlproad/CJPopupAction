//
//  UIView+CJSlide3DInterceptor.m
//  CJAnimationKit
//
//  Created by ciyouzen on 2026/7/31.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJSlide3DInterceptor.h"
#import "UIView+CJInterceptorChain.h"
#import <objc/runtime.h>

static NSMutableArray<CJSlide3DInterceptor> *_globalSlide3DInterceptors = nil;

@implementation UIView (CJSlide3DGlobalInterceptor)

+ (void)addSlide3DInterceptor:(CJSlide3DInterceptor)interceptor {
    if (!_globalSlide3DInterceptors) {
        _globalSlide3DInterceptors = [NSMutableArray array];
    }
    [_globalSlide3DInterceptors addObject:[interceptor copy]];
}

+ (void)removeSlide3DInterceptor:(CJSlide3DInterceptor)interceptor {
    [_globalSlide3DInterceptors removeObject:interceptor];
}

+ (void)removeAllSlide3DInterceptors {
    [_globalSlide3DInterceptors removeAllObjects];
}

+ (nullable NSArray<CJSlide3DInterceptor> *)cj_slide3DGlobalInterceptors {
    return _globalSlide3DInterceptors;
}

@end

@implementation UIView (CJSlide3DInstanceInterceptor)

- (NSArray<CJSlide3DInterceptor> *)slide3DInterceptors {
    return objc_getAssociatedObject(self, @selector(slide3DInterceptors));
}

- (void)setSlide3DInterceptors:(NSArray<CJSlide3DInterceptor> *)slide3DInterceptors {
    objc_setAssociatedObject(self, @selector(slide3DInterceptors), slide3DInterceptors, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)addInstanceSlide3DInterceptor:(CJSlide3DInterceptor)interceptor {
    NSMutableArray *interceptors = [NSMutableArray arrayWithArray:self.slide3DInterceptors ?: @[]];
    [interceptors addObject:[interceptor copy]];
    self.slide3DInterceptors = interceptors;
}

- (void)removeInstanceSlide3DInterceptor:(CJSlide3DInterceptor)interceptor {
    NSMutableArray *interceptors = [NSMutableArray arrayWithArray:self.slide3DInterceptors ?: @[]];
    [interceptors removeObject:interceptor];
    self.slide3DInterceptors = interceptors;
}

- (void)removeAllInstanceSlide3DInterceptors {
    self.slide3DInterceptors = @[];
}

@end
