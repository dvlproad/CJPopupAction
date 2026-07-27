//
//  UIView+CJExpandFrameAnimation.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJExpandFrameAnimation.h"
#import <objc/runtime.h>

static NSMutableArray<CJExpandInterceptor> *_expandInterceptors = nil;

@implementation UIView (CJExpandFrameAnimation)

+ (void)cj_expandAnimateView:(UIView *)animatedView
                      forShow:(BOOL)forShow
                withShowFrame:(CGRect)popupViewShowFrame
                    hideFrame:(CGRect)popupViewHideFrame
                    blankView:(nullable UIView *)blankView
                   completion:(void(^)(void))completion
{
    if (_expandInterceptors.count == 0) {
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
    void(^chain)(NSInteger index) = nil;
    
    chain = ^(NSInteger index) {
        if (index >= _expandInterceptors.count) {
            // 链结束，执行默认
            [self cj_expandAnimateView_default:animatedView
                                       forShow:forShow
                                 withShowFrame:popupViewShowFrame
                                     hideFrame:popupViewHideFrame
                                     blankView:blankView
                                    completion:completion];
            return;
        }
        
        CJExpandInterceptor interceptor = _expandInterceptors[index];
        interceptor(animatedView, forShow, popupViewShowFrame, popupViewHideFrame, blankView, ^{
            chain(index + 1);
        });
    };
    
    chain(0);
}

+ (void)cj_expandAnimateView_default:(UIView *)animatedView
                              forShow:(BOOL)forShow
                        withShowFrame:(CGRect)popupViewShowFrame
                            hideFrame:(CGRect)popupViewHideFrame
                            blankView:(nullable UIView *)blankView
                           completion:(void(^)(void))completion
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

#pragma mark - 拦截器
@implementation UIView (CJExpandFrameInterceptor)

+ (void)addExpandInterceptor:(CJExpandInterceptor)interceptor {
    if (!_expandInterceptors) {
        _expandInterceptors = [NSMutableArray array];
    }
    [_expandInterceptors addObject:[interceptor copy]];
}

+ (void)removeExpandInterceptor:(CJExpandInterceptor)interceptor {
    [_expandInterceptors removeObject:interceptor];
}

+ (void)removeAllExpandInterceptors {
    [_expandInterceptors removeAllObjects];
}

@end
