//
//  UIView+CJSlideTransformAnimationBind.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJSlideTransformAnimationBind.h"
#import <objc/runtime.h>

@implementation UIView (CJSlideTransformAnimationBind)

#pragma mark - 普通平移（进阶）
+ (void)cj_showSlideAnimateBindView:(UIView *)animatedView
                    withShowDirection:(CJSlideFromDirection)showFromDirection
                        animateOffset:(CGFloat)animateOffset
                           completion:(void (^ __nullable)(BOOL finished))completion {
    animatedView.cjShowFromDirection = showFromDirection;
    animatedView.cjAnimateOffset = animateOffset;
    [UIView cj_slideAnimateView:animatedView
                        forShow:YES
               withShowDirection:showFromDirection
                   animateOffset:animateOffset
                      completion:completion];
}

+ (void)cj_hideSlideAnimateBindView:(UIView *)animatedView
                          completion:(void (^ __nullable)(BOOL finished))completion {
    [UIView cj_slideAnimateView:animatedView
                        forShow:NO
               withShowDirection:animatedView.cjShowFromDirection
                   animateOffset:animatedView.cjAnimateOffset
                      completion:completion];
}

#pragma mark - 3D平移（进阶）
+ (void)cj_show3DSlideAnimateBindView:(UIView *)animatedView
                    withShowDirection:(CJSlideFromDirection)showFromDirection
                        animateOffset:(CGFloat)animateOffset
                          rotateAngle:(CGFloat)rotateAngle
                           completion:(void (^ __nullable)(BOOL finished))completion {
    animatedView.cjShowFromDirection = showFromDirection;
    animatedView.cjAnimateOffset = animateOffset;
    animatedView.cjRotateAngle = rotateAngle;
    [UIView cj_slide3DAnimateView:animatedView
                          forShow:YES
                 withShowDirection:showFromDirection
                     animateOffset:animateOffset
                       rotateAngle:rotateAngle
                        completion:completion];
}

+ (void)cj_hide3DSlideAnimateBindView:(UIView *)animatedView
                           completion:(void (^ __nullable)(BOOL finished))completion {
    [UIView cj_slide3DAnimateView:animatedView
                          forShow:NO
                 withShowDirection:animatedView.cjShowFromDirection
                     animateOffset:animatedView.cjAnimateOffset
                       rotateAngle:animatedView.cjRotateAngle
                        completion:completion];
}

@end

@implementation UIView (CJSlideTransformAnimationBindProperty)

#pragma mark - Runtime: Assign
- (CJSlideFromDirection)cjShowFromDirection {
    return [objc_getAssociatedObject(self, @selector(cjShowFromDirection)) integerValue];
}

- (void)setCjShowFromDirection:(CJSlideFromDirection)cjShowFromDirection {
    objc_setAssociatedObject(self, @selector(cjShowFromDirection), @(cjShowFromDirection), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)cjAnimateOffset {
    return [objc_getAssociatedObject(self, @selector(cjAnimateOffset)) floatValue];
}

- (void)setCjAnimateOffset:(CGFloat)cjAnimateOffset {
    objc_setAssociatedObject(self, @selector(cjAnimateOffset), @(cjAnimateOffset), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)cjRotateAngle {
    return [objc_getAssociatedObject(self, @selector(cjRotateAngle)) floatValue];
}

- (void)setCjRotateAngle:(CGFloat)cjRotateAngle {
    objc_setAssociatedObject(self, @selector(cjRotateAngle), @(cjRotateAngle), OBJC_ASSOCIATION_ASSIGN);
}

@end
