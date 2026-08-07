//
//  UIView+CJExpandRectAnimation.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJExpandRectAnimation.h"
#import "UIView+CJInterceptorChain.h"

@implementation UIView (CJExpandRectAnimation)

#pragma mark - 核心方法（block 驱动）
+ (void)cj_expandAnimateView:(UIView *)animatedView
                      forShow:(BOOL)forShow
                  animateBlock:(CJExpandAnimateBlock)animateBlock
                    completion:(nullable void(^)(void))completion
{
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
                               animateBlock:animateBlock
                                 completion:completion];
        return;
    }
    
    // 构建拦截器链
    NSMutableArray *chainInterceptors = [NSMutableArray arrayWithCapacity:allInterceptors.count];
    for (CJExpandInterceptor interceptor in allInterceptors) {
        [chainInterceptors addObject:^(void(^next)(void)) {
            interceptor(animatedView, forShow, animateBlock, next);
        }];
    }
    
    [UIView cj_runInterceptorChain:chainInterceptors withDefaultBlock:^{
        [self cj_expandAnimateView_default:animatedView
                                   forShow:forShow
                               animateBlock:animateBlock
                                 completion:completion];
    }];
}

+ (void)cj_expandAnimateView_default:(UIView *)animatedView
                              forShow:(BOOL)forShow
                         animateBlock:(CJExpandAnimateBlock)animateBlock
                            completion:(nullable void(^)(void))completion
{
    // 两阶段：先设置初始状态并立即布局，再动画到目标状态
    animateBlock(animatedView, !forShow);
    [animatedView.superview layoutIfNeeded];
    
    [UIView animateWithDuration:kCJPopupAnimationDuration animations:^{
        animateBlock(animatedView, forShow);
        [animatedView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        !completion ?: completion();
    }];
}

@end
