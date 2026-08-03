//
//  UIView+CJSlide3DInterceptor.h
//  CJAnimationKit
//
//  Created by ciyouzen on 2026/7/31.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//
//  3D 位移动画拦截器：全局拦截器(类级别) + 实例拦截器(per-view)

#import <UIKit/UIKit.h>
#import "CJSlideCalculator.h"   // 需要 CJSlideFromDirection

NS_ASSUME_NONNULL_BEGIN

typedef void(^CJSlide3DInterceptor)(UIView *animatedView, BOOL forShow,
                                    CJSlideFromDirection showFromDirection,
                                    CGFloat animateOffset,
                                    CGFloat rotateAngle,
                                    void(^next)(void));

#pragma mark - 全局拦截器（类级别）
@interface UIView (CJSlide3DGlobalInterceptor)

+ (void)addSlide3DInterceptor:(CJSlide3DInterceptor)interceptor;
+ (void)removeSlide3DInterceptor:(CJSlide3DInterceptor)interceptor;
+ (void)removeAllSlide3DInterceptors;

/// 内部使用：获取全部全局拦截器（用于构建拦截器链）
+ (nullable NSArray<CJSlide3DInterceptor> *)cj_slide3DGlobalInterceptors;

@end

#pragma mark - 实例拦截器（per-view）
@interface UIView (CJSlide3DInstanceInterceptor)

@property (nonatomic, copy, nullable) NSArray<CJSlide3DInterceptor> *slide3DInterceptors;

- (void)addInstanceSlide3DInterceptor:(CJSlide3DInterceptor)interceptor;
- (void)removeInstanceSlide3DInterceptor:(CJSlide3DInterceptor)interceptor;
- (void)removeAllInstanceSlide3DInterceptors;

@end

NS_ASSUME_NONNULL_END
