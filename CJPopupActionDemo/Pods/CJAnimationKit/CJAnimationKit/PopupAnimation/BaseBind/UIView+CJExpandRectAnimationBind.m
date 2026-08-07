//
//  UIView+CJExpandRectAnimationBind.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJExpandRectAnimationBind.h"
#import "CJExpandCalculator.h"
#import <objc/runtime.h>

@implementation UIView (CJExpandRectAnimationBind)

#pragma mark - 展开动画（进阶）
+ (void)cj_showExpandAnimateBindView:(UIView *)animatedView
                        withShowFrame:(CGRect)showFrame
                            direction:(CJExpandToDirection)direction
                            blankView:(nullable UIView *)blankView
                           completion:(nullable void(^)(void))completion {
    CGRect popupViewHideFrame = [CJExpandCalculator hideFrameFromShowFrame:showFrame direction:direction];
    animatedView.cjExpandAnimateBlock = ^(UIView *animatedView, BOOL forShow) {
        if (blankView != nil) {
            blankView.alpha = forShow ? 1.0 : 0.0;
        }
        animatedView.alpha = forShow ? 1.0 : 0.0;
        animatedView.frame = forShow ? showFrame : popupViewHideFrame;
    };
    [UIView cj_expandAnimateView:animatedView
                         forShow:YES
                     animateBlock:animatedView.cjExpandAnimateBlock
                       completion:completion];
}

+ (void)cj_showExpandAnimateBindView:(UIView *)animatedView
                         animateBlock:(CJExpandAnimateBlock)animateBlock
                           completion:(nullable void(^)(void))completion {
    animatedView.cjExpandAnimateBlock = animateBlock;
    [UIView cj_expandAnimateView:animatedView
                         forShow:YES
                     animateBlock:animateBlock
                       completion:completion];
}

+ (void)cj_hideExpandAnimateBindView:(UIView *)animatedView
                           completion:(nullable void(^)(void))completion {
    [UIView cj_expandAnimateView:animatedView
                         forShow:NO
                     animateBlock:animatedView.cjExpandAnimateBlock
                       completion:completion];
}

@end

@implementation UIView (CJExpandRectAnimationBindProperty)

#pragma mark - Runtime
- (CJExpandAnimateBlock)cjExpandAnimateBlock {
    return objc_getAssociatedObject(self, @selector(cjExpandAnimateBlock));
}

- (void)setCjExpandAnimateBlock:(CJExpandAnimateBlock)cjExpandAnimateBlock {
    objc_setAssociatedObject(self, @selector(cjExpandAnimateBlock), cjExpandAnimateBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
