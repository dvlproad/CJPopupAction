//
//  UIView+CJExpandFrameAnimationBind.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJExpandFrameAnimationBind.h"
#import <objc/runtime.h>

@implementation UIView (CJExpandFrameAnimationBind)

#pragma mark - 展开动画（进阶）
+ (void)cj_showExpandAnimateBindView:(UIView *)animatedView
                        withShowFrame:(CGRect)showFrame
                            direction:(CJExpandToDirection)direction
                            blankView:(nullable UIView *)blankView
                           completion:(nullable void(^)(void))completion {
    animatedView.cjExpandShowFrame = showFrame;
    animatedView.cjExpandDirection = direction;
    animatedView.cjExpandBlankView = blankView;
    [UIView cj_expandAnimateView:animatedView
                         forShow:YES
                   withShowFrame:showFrame
                       direction:direction
                       blankView:blankView
                      completion:completion];
}

+ (void)cj_hideExpandAnimateBindView:(UIView *)animatedView
                           completion:(nullable void(^)(void))completion {
    [UIView cj_expandAnimateView:animatedView
                         forShow:NO
                   withShowFrame:animatedView.cjExpandShowFrame
                       direction:animatedView.cjExpandDirection
                       blankView:animatedView.cjExpandBlankView
                      completion:completion];
}

@end

@implementation UIView (CJExpandFrameAnimationBindProperty)

#pragma mark - Runtime
- (CGRect)cjExpandShowFrame {
    NSValue *value = objc_getAssociatedObject(self, @selector(cjExpandShowFrame));
    return value ? [value CGRectValue] : CGRectZero;
}

- (void)setCjExpandShowFrame:(CGRect)cjExpandShowFrame {
    objc_setAssociatedObject(self, @selector(cjExpandShowFrame), [NSValue valueWithCGRect:cjExpandShowFrame], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CJExpandToDirection)cjExpandDirection {
    NSNumber *value = objc_getAssociatedObject(self, @selector(cjExpandDirection));
    return value ? [value unsignedIntegerValue] : CJExpandToDirectionCenter;
}

- (void)setCjExpandDirection:(CJExpandToDirection)cjExpandDirection {
    objc_setAssociatedObject(self, @selector(cjExpandDirection), @(cjExpandDirection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)cjExpandBlankView {
    return objc_getAssociatedObject(self, @selector(cjExpandBlankView));
}

- (void)setCjExpandBlankView:(UIView *)cjExpandBlankView {
    objc_setAssociatedObject(self, @selector(cjExpandBlankView), cjExpandBlankView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
