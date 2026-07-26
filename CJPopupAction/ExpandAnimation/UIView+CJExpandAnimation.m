//
//  UIView+CJExpandAnimation.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJExpandAnimation.h"

@implementation UIView (CJExpandAnimation)


- (void)cj_expandAnimateForShow:(BOOL)forShow
                  withShowFrame:(CGRect)popupViewShowFrame
                      hideFrame:(CGRect)popupViewHideFrame
                      blankView:(nullable UIView *)blankView
                     completion:(void(^)(void))completion
{
//    CGFloat showAlpha = forShow ? 0.2 : 1.0;
//    CGFloat hideAlpah = forShow ? 1.0 : 0.2;
    if (blankView != nil) {
        blankView.alpha = forShow ? 0.2 : 1.0;
    }
    self.frame = forShow ? popupViewHideFrame : popupViewShowFrame;
    self.alpha = forShow ? 0.2 : 1.0;
    [UIView animateWithDuration:kCJPopupAnimationDuration animations:^{
        // 隐藏的最后，alpah 要设置成 0
        if (blankView != nil) {
            blankView.alpha = forShow ? 1.0 : 0.0;
        }
        self.alpha = forShow ? 1.0 : 0.0;
        self.frame = forShow ? popupViewShowFrame : popupViewHideFrame;
    } completion:^(BOOL finished) {
        !completion ?: completion();
    }];
}

@end
