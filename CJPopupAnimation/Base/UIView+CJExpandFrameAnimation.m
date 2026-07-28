//
//  UIView+CJExpandFrameAnimation.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJExpandFrameAnimation.h"
#import "CJExpandCalculator.h"
#import <objc/runtime.h>

static NSMutableArray<CJExpandInterceptor> *_globalExpandInterceptors = nil;

@implementation UIView (CJExpandFrameAnimation)

+ (void)cj_expandAnimateView:(UIView *)animatedView
                      forShow:(BOOL)forShow
                withShowFrame:(CGRect)popupViewShowFrame
                    direction:(CJExpandToDirection)direction
                    blankView:(nullable UIView *)blankView
                   completion:(void(^)(void))completion
{
    // 根据 direction 计算 hideFrame
    CGRect popupViewHideFrame = [CJExpandCalculator hideFrameFromShowFrame:popupViewShowFrame direction:direction];
    
    NSArray<CJExpandInterceptor> *instanceInterceptors = animatedView.expandInterceptors;
    NSArray<CJExpandInterceptor> *globalInterceptors = _globalExpandInterceptors ?: @[];
    
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
    void(^chain)(NSInteger index) = nil;
    
    chain = ^(NSInteger index) {
        if (index >= allInterceptors.count) {
            // 链结束，执行默认
            [self cj_expandAnimateView_default:animatedView
                                       forShow:forShow
                                 withShowFrame:popupViewShowFrame
                                     hideFrame:popupViewHideFrame
                                     blankView:blankView
                                    completion:completion];
            return;
        }
        
        CJExpandInterceptor interceptor = allInterceptors[index];
        interceptor(animatedView, forShow, popupViewShowFrame, direction, blankView, ^{
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

#pragma mark - 全局拦截器
@implementation UIView (CJExpandFrameGlobalInterceptor)

+ (void)addExpandInterceptor:(CJExpandInterceptor)interceptor {
    if (!_globalExpandInterceptors) {
        _globalExpandInterceptors = [NSMutableArray array];
    }
    [_globalExpandInterceptors addObject:[interceptor copy]];
}

+ (void)removeExpandInterceptor:(CJExpandInterceptor)interceptor {
    [_globalExpandInterceptors removeObject:interceptor];
}

+ (void)removeAllExpandInterceptors {
    [_globalExpandInterceptors removeAllObjects];
}

@end

#pragma mark - 实例拦截器
@implementation UIView (CJExpandFrameInstanceInterceptor)

- (NSArray<CJExpandInterceptor> *)expandInterceptors {
    return objc_getAssociatedObject(self, @selector(expandInterceptors));
}

- (void)setExpandInterceptors:(NSArray<CJExpandInterceptor> *)expandInterceptors {
    objc_setAssociatedObject(self, @selector(expandInterceptors), expandInterceptors, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)addInstanceExpandInterceptor:(CJExpandInterceptor)interceptor {
    NSMutableArray *interceptors = [NSMutableArray arrayWithArray:self.expandInterceptors ?: @[]];
    [interceptors addObject:[interceptor copy]];
    self.expandInterceptors = interceptors;
}

- (void)removeInstanceExpandInterceptor:(CJExpandInterceptor)interceptor {
    NSMutableArray *interceptors = [NSMutableArray arrayWithArray:self.expandInterceptors ?: @[]];
    [interceptors removeObject:interceptor];
    self.expandInterceptors = interceptors;
}

- (void)removeAllInstanceExpandInterceptors {
    self.expandInterceptors = @[];
}

@end
