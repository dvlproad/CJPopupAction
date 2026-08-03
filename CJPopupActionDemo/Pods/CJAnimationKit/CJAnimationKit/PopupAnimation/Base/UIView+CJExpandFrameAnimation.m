//
//  UIView+CJExpandFrameAnimation.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJExpandFrameAnimation.h"
#import "UIView+CJInterceptorChain.h"
#import "CJExpandCalculator.h"

@implementation UIView (CJExpandFrameAnimation)

+ (void)cj_expandAnimateView:(UIView *)animatedView
                      forShow:(BOOL)forShow
                withShowFrame:(CGRect)popupViewShowFrame
                    direction:(CJExpandToDirection)direction
                    blankView:(nullable UIView *)blankView
                   completion:(nullable void(^)(void))completion
{
    // 根据 direction 计算 hideFrame
    CGRect popupViewHideFrame = [CJExpandCalculator hideFrameFromShowFrame:popupViewShowFrame direction:direction];
    
    NSArray<CJExpandInterceptor> *instanceInterceptors = animatedView.expandInterceptors;
    NSArray<CJExpandInterceptor> *globalInterceptors = [UIView cj_expandGlobalInterceptors];
    
    // 合并：实例拦截器在前，全局拦截器在后
    NSMutableArray<CJExpandInterceptor> *allInterceptors = [NSMutableArray array];
    if (instanceInterceptors.count > 0) {
        [allInterceptors addObjectsFromArray:instanceInterceptors];
    }
    if (globalInterceptors.count > 0) {
        [allInterceptors addObjectsFromArray:globalInterceptors];
    }
    
    if (allInterceptors.count == 0) {
        // 无拦截器，直接执行默认
        [self cj_expandAnimateView_default:animatedView
                                   forShow:forShow
                             withShowFrame:popupViewShowFrame
                                 hideFrame:popupViewHideFrame
                                 blankView:blankView
                                completion:completion];
        return;
    }
    
    // 构建拦截器链
    NSMutableArray *chainInterceptors = [NSMutableArray arrayWithCapacity:allInterceptors.count];
    for (CJExpandInterceptor interceptor in allInterceptors) {
        [chainInterceptors addObject:^(void(^next)(void)) {
            interceptor(animatedView, forShow, popupViewShowFrame, direction, blankView, next);
        }];
    }
    
    [UIView cj_runInterceptorChain:chainInterceptors withDefaultBlock:^{
        [self cj_expandAnimateView_default:animatedView
                                   forShow:forShow
                             withShowFrame:popupViewShowFrame
                                 hideFrame:popupViewHideFrame
                                 blankView:blankView
                                completion:completion];
    }];
}

+ (void)cj_expandAnimateView_default:(UIView *)animatedView
                              forShow:(BOOL)forShow
                        withShowFrame:(CGRect)popupViewShowFrame
                            hideFrame:(CGRect)popupViewHideFrame
                            blankView:(nullable UIView *)blankView
                           completion:(nullable void(^)(void))completion
{
    if (blankView != nil) {
        blankView.alpha = forShow ? 0.2 : 1.0;
    }
    animatedView.frame = forShow ? popupViewHideFrame : popupViewShowFrame;
    animatedView.alpha = forShow ? 0.2 : 1.0;
    [UIView animateWithDuration:kCJPopupAnimationDuration animations:^{
        if (blankView != nil) {
            blankView.alpha = forShow ? 1.0 : 0.0;
        }
        animatedView.alpha = forShow ? 1.0 : 0.0;
        animatedView.frame = forShow ? popupViewShowFrame : popupViewHideFrame;
    } completion:^(BOOL finished) {
        !completion ?: completion();
    }];
}

@end
