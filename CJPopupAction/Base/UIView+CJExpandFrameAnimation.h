//
//  UIView+CJExpandFrameAnimation.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//
//  展开动画：不一定需要blankView

#import <UIKit/UIKit.h>
#import "CJExpandCalculator.h"   // 需要 CJExpandToDirection

static CGFloat kCJPopupAnimationDuration = 0.3;

NS_ASSUME_NONNULL_BEGIN

typedef void(^CJExpandAnimateBlock)(UIView *animatedView, BOOL forShow,
                                    CGRect showFrame, CJExpandToDirection direction,
                                    UIView * _Nullable blankView,
                                    void(^ _Nullable completion)(void));

typedef void(^CJExpandInterceptor)(UIView *animatedView, BOOL forShow,
                                    CGRect showFrame, CJExpandToDirection direction,
                                    UIView * _Nullable blankView,
                                    void(^next)(void));

#pragma mark - 类方法
@interface UIView (CJExpandFrameAnimation)

+ (void)cj_expandAnimateView:(UIView *)animatedView
                      forShow:(BOOL)forShow
                withShowFrame:(CGRect)popupViewShowFrame
                    direction:(CJExpandToDirection)direction
                    blankView:(nullable UIView *)blankView
                   completion:(void(^)(void))completion;

@end

#pragma mark - 全局拦截器（类级别）
@interface UIView (CJExpandFrameGlobalInterceptor)

+ (void)addExpandInterceptor:(CJExpandInterceptor)interceptor;
+ (void)removeExpandInterceptor:(CJExpandInterceptor)interceptor;
+ (void)removeAllExpandInterceptors;

@end

#pragma mark - 实例拦截器（per-view）
@interface UIView (CJExpandFrameInstanceInterceptor)

@property (nonatomic, copy, nullable) NSArray<CJExpandInterceptor> *expandInterceptors;

- (void)addInstanceExpandInterceptor:(CJExpandInterceptor)interceptor;
- (void)removeInstanceExpandInterceptor:(CJExpandInterceptor)interceptor;
- (void)removeAllInstanceExpandInterceptors;

@end

NS_ASSUME_NONNULL_END
