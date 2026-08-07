//
//  UIView+CJExpandInterceptor.h
//  CJAnimationKit
//
//  Created by ciyouzen on 2026/7/31.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//
//  展开动画拦截器：全局拦截器(类级别) + 实例拦截器(per-view)

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 展开动画的"状态设置"block：把 animatedView 设置成显示/隐藏状态（通常通过修改约束实现）
/// @param animatedView 动画视图
/// @param forShow 是否为目标显示状态（YES=显示，NO=隐藏）
typedef void(^CJExpandAnimateBlock)(UIView *animatedView, BOOL forShow);

typedef void(^CJExpandInterceptor)(UIView *animatedView, BOOL forShow,
                                   CJExpandAnimateBlock animateBlock,
                                   void(^ _Nullable next)(void));

#pragma mark - 全局拦截器（类级别）
@interface UIView (CJExpandGlobalInterceptor)

+ (void)addExpandInterceptor:(CJExpandInterceptor)interceptor;
+ (void)removeExpandInterceptor:(CJExpandInterceptor)interceptor;
+ (void)removeAllExpandInterceptors;

/// 内部使用：获取全部全局拦截器（用于构建拦截器链）
+ (nullable NSArray<CJExpandInterceptor> *)cj_expandGlobalInterceptors;

@end

#pragma mark - 实例拦截器（per-view）
@interface UIView (CJExpandInstanceInterceptor)

@property (nonatomic, copy, nullable) NSArray<CJExpandInterceptor> *expandInterceptors;

- (void)addInstanceExpandInterceptor:(CJExpandInterceptor)interceptor;
- (void)removeInstanceExpandInterceptor:(CJExpandInterceptor)interceptor;
- (void)removeAllInstanceExpandInterceptors;

@end

NS_ASSUME_NONNULL_END
