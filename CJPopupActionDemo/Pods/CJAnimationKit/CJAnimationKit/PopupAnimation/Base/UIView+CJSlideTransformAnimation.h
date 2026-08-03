//
//  UIView+CJSlideTransformAnimation.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//
//  位移动画（普通平移、3D平移）可以直接用此方法。（位移动画在有 blankBGView 时，其alpha也不适合做动画变化，而是初始就显示好）

#import <UIKit/UIKit.h>
#import "UIView+CJSlideInterceptor.h"     // 需要 CJSlideFromDirection、CJSlideInterceptor
#import "UIView+CJSlide3DInterceptor.h"   // 需要 CJSlideFromDirection、CJSlide3DInterceptor

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

NS_ASSUME_NONNULL_END
