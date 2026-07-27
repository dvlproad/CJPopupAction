//
//  UIView+CJExpandFrameAnimation.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJExpandFrameAnimation.h"

@implementation UIView (CJExpandFrameAnimation)


+ (void)cj_expandAnimateView:(UIView *)animatedView
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
