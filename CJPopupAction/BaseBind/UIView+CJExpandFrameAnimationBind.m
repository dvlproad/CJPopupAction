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
+ (void)cj_showExpandAnimateBindView:(UIView *)view
                        withShowFrame:(CGRect)showFrame
                            hideFrame:(CGRect)hideFrame
                            blankView:(nullable UIView *)blankView
                           completion:(void(^)(void))completion {
    view.cjExpandShowFrame = showFrame;
    view.cjExpandHideFrame = hideFrame;
    view.cjExpandBlankView = blankView;
    [UIView cj_expandAnimateView:view
                          forShow:YES
                    withShowFrame:showFrame
                        hideFrame:hideFrame
                        blankView:blankView
                       completion:completion];
}

+ (void)cj_hideExpandAnimateBindView:(UIView *)view
                           completion:(void(^)(void))completion {
    [UIView cj_expandAnimateView:view
                          forShow:NO
                    withShowFrame:view.cjExpandShowFrame
                        hideFrame:view.cjExpandHideFrame
                        blankView:view.cjExpandBlankView
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

- (CGRect)cjExpandHideFrame {
    NSValue *value = objc_getAssociatedObject(self, @selector(cjExpandHideFrame));
    return value ? [value CGRectValue] : CGRectZero;
}

- (void)setCjExpandHideFrame:(CGRect)cjExpandHideFrame {
    objc_setAssociatedObject(self, @selector(cjExpandHideFrame), [NSValue valueWithCGRect:cjExpandHideFrame], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)cjExpandBlankView {
    return objc_getAssociatedObject(self, @selector(cjExpandBlankView));
}

- (void)setCjExpandBlankView:(UIView *)cjExpandBlankView {
    objc_setAssociatedObject(self, @selector(cjExpandBlankView), cjExpandBlankView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
