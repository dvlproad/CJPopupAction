//
//  UIView+CJSlideConvenience.m
//  CJPopupAction
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJSlideConvenience.h"
#import "UIView+CJSlideTransformAnimationBind.h"

@implementation UIView (CJSlideConvenience)

- (void)cq_slideFromWindowDirection:(CJSlideFromDirection)direction {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect convertFrame = [self.superview convertRect:self.frame toView:keyWindow];
    CGRect targetFrame = keyWindow.bounds;
    
    CGFloat spacing = 0;
    switch (direction) {
        case CJSlideFromDirectionTop:
            spacing = CGRectGetMaxY(convertFrame);
            break;
        case CJSlideFromDirectionBottom:
            spacing = CGRectGetHeight(targetFrame) - CGRectGetMinY(convertFrame);
            break;
        case CJSlideFromDirectionLeft:
            spacing = CGRectGetMaxX(convertFrame);
            break;
        case CJSlideFromDirectionRight:
            spacing = CGRectGetWidth(targetFrame) - CGRectGetMinX(convertFrame);
            break;
    }
    
    [self cq_slideFromOffset:spacing direction:direction];
}

- (void)cq_slideFromOffset:(CGFloat)offset
                 direction:(CJSlideFromDirection)showFromDirection {
    [UIView cj_showSlideAnimateBindView:self
                       withShowDirection:showFromDirection
                           animateOffset:offset
                              completion:nil];
}

- (void)cq_slideSmallForHideWithAnimate:(BOOL)animate {
    if (animate) {
        [UIView cj_hideSlideAnimateBindView:self completion:nil];
    } else {
        self.alpha = 0;
    }
}

@end
