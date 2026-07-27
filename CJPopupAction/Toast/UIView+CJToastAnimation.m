//
//  UIView+CJToastAnimation.m
//  CJPopupAction
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJToastAnimation.h"

@implementation UIView (CJToastAnimation)

- (void)cj_toastCenterInView:(nullable UIView *)superView
                    withSize:(CGSize)size
                centerOffset:(CGPoint)centerOffset
                    animated:(BOOL)animated
{
    if (superView == nil) {
        superView = [UIApplication sharedApplication].keyWindow;
    }
    [superView addSubview:self];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addConstraint:
     [NSLayoutConstraint constraintWithItem:self
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:superView
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:centerOffset.x]];
    
    [superView addConstraint:
     [NSLayoutConstraint constraintWithItem:self
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:superView
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:centerOffset.y]];
    
    [superView addConstraint:
     [NSLayoutConstraint constraintWithItem:self
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:size.width]];
    
    [superView addConstraint:
     [NSLayoutConstraint constraintWithItem:self
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:size.height]];
    
    [self __cj_toastUpdateAlpha:1 animated:animated completion:NULL];
}

- (void)cj_toastHiddenWithAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self __cj_toastUpdateAlpha:0 animated:animated completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
}

#pragma mark - Private Method
- (void)__cj_toastUpdateAlpha:(CGFloat)alpha
                     animated:(BOOL)animated
                   completion:(void(^)(BOOL finished))completion
{
    if (animated == NO) {
        self.alpha = alpha;
        !completion ?: completion(YES);
        return;
    }
    
    dispatch_block_t animations = ^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = alpha;
    };
    [UIView animateWithDuration:0.3
                          delay:0.
         usingSpringWithDamping:1.f
          initialSpringVelocity:0.f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:animations
                     completion:completion];
}

@end
