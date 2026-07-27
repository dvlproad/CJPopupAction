//
//  UIView+CJSlideTransformAnimation.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJSlideTransformAnimation.h"

@implementation UIView (CJSlideTransformAnimation)

#pragma mark - 普通平移（类方法）
+ (void)cj_slideAnimateView:(UIView *)animatedView
                    forShow:(BOOL)forShow
           withShowDirection:(CJSlideFromDirection)showFromDirection
               animateOffset:(CGFloat)animateOffset
                  completion:(void (^ __nullable)(BOOL finished))completion
{
    [animatedView.superview layoutIfNeeded];
    
    if (forShow) {
        [UIView __updateTransformFromDirection:showFromDirection animateOffset:animateOffset view:animatedView];
        
        animatedView.alpha = 0;
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            animatedView.transform = CGAffineTransformIdentity;
            animatedView.alpha = 1;
        } completion:completion];
    } else {
        animatedView.transform = CGAffineTransformIdentity;
        
        animatedView.alpha = 1;
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [UIView __updateTransformFromDirection:showFromDirection animateOffset:animateOffset view:animatedView];
            animatedView.alpha = 0;
        } completion:completion];
    }
}


#pragma mark - 3D平移（类方法）
+ (void)cj_slide3DAnimateView:(UIView *)animatedView
                      forShow:(BOOL)forShow
             withShowDirection:(CJSlideFromDirection)showFromDirection
                 animateOffset:(CGFloat)animateOffset
                   rotateAngle:(CGFloat)rotateAngle
                    completion:(void (^ __nullable)(BOOL finished))completion
{
    [animatedView.superview layoutIfNeeded];

    CGFloat zAxis = (showFromDirection == CJSlideFromDirectionLeft ||
                     showFromDirection == CJSlideFromDirectionTop) ? 1.0 : -1.0;

    CATransform3D hideTransform3D = [UIView __updateTransform3DFromDirection:showFromDirection
                                                            animateOffset:animateOffset
                                                               rotateAngle:rotateAngle
                                                                    zAxis:zAxis];

    if (forShow) {
        animatedView.layer.transform = hideTransform3D;
        animatedView.alpha = 0;
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            animatedView.layer.transform = CATransform3DIdentity;
            animatedView.alpha = 1;
        } completion:completion];
    } else {
        animatedView.layer.transform = CATransform3DIdentity;
        animatedView.alpha = 1;
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            animatedView.layer.transform = hideTransform3D;
            animatedView.alpha = 0;
        } completion:completion];
    }
}


#pragma mark - Private Method
+ (void)__updateTransformFromDirection:(CJSlideFromDirection)direction
                         animateOffset:(CGFloat)animateOffset
                                  view:(UIView *)view
{
    CGAffineTransform transform;
    if (direction == CJSlideFromDirectionTop) {
        transform = CGAffineTransformMakeTranslation(0, -animateOffset);
    } else if (direction == CJSlideFromDirectionBottom) {
        transform = CGAffineTransformMakeTranslation(0, animateOffset);
    } else if (direction == CJSlideFromDirectionLeft) {
        transform = CGAffineTransformMakeTranslation(-animateOffset, 0);
    } else if (direction == CJSlideFromDirectionRight) {
        transform = CGAffineTransformMakeTranslation(animateOffset, 0);
    } else {
        transform = CGAffineTransformMakeTranslation(0, animateOffset);
    }
    
    view.transform = transform;
}

+ (CATransform3D)__updateTransform3DFromDirection:(CJSlideFromDirection)direction
                                    animateOffset:(CGFloat)animateOffset
                                       rotateAngle:(CGFloat)rotateAngle
                                            zAxis:(CGFloat)zAxis
{
    CATransform3D translate = CATransform3DIdentity;
    if (direction == CJSlideFromDirectionTop) {
        translate = CATransform3DMakeTranslation(0, -animateOffset, 0);
    } else if (direction == CJSlideFromDirectionBottom) {
        translate = CATransform3DMakeTranslation(0, animateOffset, 0);
    } else if (direction == CJSlideFromDirectionLeft) {
        translate = CATransform3DMakeTranslation(-animateOffset, 0, 0);
    } else if (direction == CJSlideFromDirectionRight) {
        translate = CATransform3DMakeTranslation(animateOffset, 0, 0);
    }

    CATransform3D rotate = CATransform3DMakeRotation(rotateAngle, 0.0, 0.0, zAxis);

    return CATransform3DConcat(rotate, translate);
}

@end
