//
//  UIView+CJSlideTransformAnimation.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//
//  位移动画（普通平移、3D平移）可以直接用此方法。（位移动画在有 blankBGView 时，其alpha也不适合做动画变化，而是初始就显示好）

#import <UIKit/UIKit.h>
#import "CJSlideCalculator.h"   // 需要 CJSlideFromDirection

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CJSlideAnimationType) {
    CJSlideAnimationTypeNone = 0,   // 无平移效果，直接显示
    CJSlideAnimationTypeNormal,     // 普通平移
    CJSlideAnimationType3D,         // 3D 平移
};

typedef void(^CJSlideAnimateBlock)(UIView *animatedView, BOOL forShow,
                                   CJSlideFromDirection showFromDirection,
                                   CGFloat animateOffset,
                                   void(^ _Nullable completion)(BOOL finished));

typedef void(^CJSlide3DAnimateBlock)(UIView *animatedView, BOOL forShow,
                                     CJSlideFromDirection showFromDirection,
                                     CGFloat animateOffset,
                                     CGFloat rotateAngle,
                                     void(^ _Nullable completion)(BOOL finished));

typedef void(^CJSlideInterceptor)(UIView *animatedView, BOOL forShow,
                                   CJSlideFromDirection showFromDirection,
                                   CGFloat animateOffset,
                                   void(^next)(void));

typedef void(^CJSlide3DInterceptor)(UIView *animatedView, BOOL forShow,
                                     CJSlideFromDirection showFromDirection,
                                     CGFloat animateOffset,
                                     CGFloat rotateAngle,
                                     void(^next)(void));

#pragma mark - 类方法
@interface UIView (CJSlideTransformAnimation)

#pragma mark - 普通平移（类方法）
+ (void)cj_slideAnimateView:(UIView *)animatedView
                    forShow:(BOOL)forShow
           withShowDirection:(CJSlideFromDirection)showFromDirection
               animateOffset:(CGFloat)animateOffset
                  completion:(void (^ __nullable)(BOOL finished))completion;

#pragma mark - 3D平移（类方法）
+ (void)cj_slide3DAnimateView:(UIView *)animatedView
                      forShow:(BOOL)forShow
             withShowDirection:(CJSlideFromDirection)showFromDirection
                 animateOffset:(CGFloat)animateOffset
                   rotateAngle:(CGFloat)rotateAngle
                    completion:(void (^ __nullable)(BOOL finished))completion;

@end

#pragma mark - 全局拦截器（类级别）
@interface UIView (CJSlideTransformGlobalInterceptor)

+ (void)addSlideInterceptor:(CJSlideInterceptor)interceptor;
+ (void)removeSlideInterceptor:(CJSlideInterceptor)interceptor;
+ (void)removeAllSlideInterceptors;

+ (void)addSlide3DInterceptor:(CJSlide3DInterceptor)interceptor;
+ (void)removeSlide3DInterceptor:(CJSlide3DInterceptor)interceptor;
+ (void)removeAllSlide3DInterceptors;

@end

#pragma mark - 实例拦截器（per-view）
@interface UIView (CJSlideTransformInstanceInterceptor)

@property (nonatomic, copy, nullable) NSArray<CJSlideInterceptor> *slideInterceptors;
@property (nonatomic, copy, nullable) NSArray<CJSlide3DInterceptor> *slide3DInterceptors;

- (void)addInstanceSlideInterceptor:(CJSlideInterceptor)interceptor;
- (void)removeInstanceSlideInterceptor:(CJSlideInterceptor)interceptor;
- (void)removeAllInstanceSlideInterceptors;

- (void)addInstanceSlide3DInterceptor:(CJSlide3DInterceptor)interceptor;
- (void)removeInstanceSlide3DInterceptor:(CJSlide3DInterceptor)interceptor;
- (void)removeAllInstanceSlide3DInterceptors;

@end

NS_ASSUME_NONNULL_END
