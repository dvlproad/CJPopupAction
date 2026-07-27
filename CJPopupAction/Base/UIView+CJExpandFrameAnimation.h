//
//  UIView+CJExpandFrameAnimation.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//
//  展开动画：不一定需要blankView

#import <UIKit/UIKit.h>

static CGFloat kCJPopupAnimationDuration = 0.3;

NS_ASSUME_NONNULL_BEGIN

typedef void(^CJExpandAnimateBlock)(UIView *animatedView, BOOL forShow,
                                    CGRect showFrame, CGRect hideFrame,
                                    UIView * _Nullable blankView,
                                    void(^ _Nullable completion)(void));

typedef void(^CJExpandInterceptor)(UIView *animatedView, BOOL forShow,
                                    CGRect showFrame, CGRect hideFrame,
                                    UIView * _Nullable blankView,
                                    void(^next)(void));

#pragma mark - 类方法
@interface UIView (CJExpandFrameAnimation)

+ (void)cj_expandAnimateView:(UIView *)animatedView
                      forShow:(BOOL)forShow
                withShowFrame:(CGRect)popupViewShowFrame
                    hideFrame:(CGRect)popupViewHideFrame
                    blankView:(nullable UIView *)blankView
                   completion:(void(^)(void))completion;

@end

#pragma mark - 拦截器
@interface UIView (CJExpandFrameInterceptor)

+ (void)addExpandInterceptor:(CJExpandInterceptor)interceptor;
+ (void)removeExpandInterceptor:(CJExpandInterceptor)interceptor;
+ (void)removeAllExpandInterceptors;

@end

NS_ASSUME_NONNULL_END
