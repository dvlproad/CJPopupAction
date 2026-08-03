//
//  UIView+CJSlideInterceptor.h
//  CJAnimationKit
//
//  Created by ciyouzen on 2026/7/31.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//
//  位移动画拦截器：全局拦截器(类级别) + 实例拦截器(per-view)

#import <UIKit/UIKit.h>
#import "CJSlideCalculator.h"   // 需要 CJSlideFromDirection

NS_ASSUME_NONNULL_BEGIN

typedef void(^CJSlideInterceptor)(UIView *animatedView, BOOL forShow,
                                  CJSlideFromDirection showFromDirection,
                                  CGFloat animateOffset,
                                  void(^next)(void));

#pragma mark - 全局拦截器（类级别）
@interface UIView (CJSlideGlobalInterceptor)

+ (void)addSlideInterceptor:(CJSlideInterceptor)interceptor;
+ (void)removeSlideInterceptor:(CJSlideInterceptor)interceptor;
+ (void)removeAllSlideInterceptors;

/// 内部使用：获取全部全局拦截器（用于构建拦截器链）
+ (nullable NSArray<CJSlideInterceptor> *)cj_slideGlobalInterceptors;

@end

#pragma mark - 实例拦截器（per-view）
@interface UIView (CJSlideInstanceInterceptor)

@property (nonatomic, copy, nullable) NSArray<CJSlideInterceptor> *slideInterceptors;

- (void)addInstanceSlideInterceptor:(CJSlideInterceptor)interceptor;
- (void)removeInstanceSlideInterceptor:(CJSlideInterceptor)interceptor;
- (void)removeAllInstanceSlideInterceptors;

@end

NS_ASSUME_NONNULL_END
