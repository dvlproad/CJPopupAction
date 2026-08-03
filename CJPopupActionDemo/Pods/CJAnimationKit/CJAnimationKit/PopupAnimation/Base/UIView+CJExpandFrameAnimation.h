//
//  UIView+CJExpandFrameAnimation.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//
//  展开动画：不一定需要blankView

#import <UIKit/UIKit.h>
#import "UIView+CJExpandInterceptor.h"   // 需要 CJExpandToDirection、CJExpandInterceptor

static CGFloat kCJPopupAnimationDuration = 0.3;

NS_ASSUME_NONNULL_BEGIN

typedef void(^CJExpandAnimateBlock)(UIView *animatedView, BOOL forShow,
                                    CGRect showFrame, CJExpandToDirection direction,
                                    UIView * _Nullable blankView,
                                    void(^ _Nullable completion)(void));

#pragma mark - 类方法
@interface UIView (CJExpandFrameAnimation)

+ (void)cj_expandAnimateView:(UIView *)animatedView
                      forShow:(BOOL)forShow
                withShowFrame:(CGRect)popupViewShowFrame
                    direction:(CJExpandToDirection)direction
                    blankView:(nullable UIView *)blankView
                   completion:(nullable void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
