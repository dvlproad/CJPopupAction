//
//  UIView+CJSlideTransformAnimation.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJSlideTransformAnimation.h"
#import <objc/runtime.h>

static NSMutableArray<CJSlideInterceptor> *_globalSlideInterceptors = nil;
static NSMutableArray<CJSlide3DInterceptor> *_globalSlide3DInterceptors = nil;

@implementation UIView (CJSlideTransformAnimation)

#pragma mark - 普通平移（类方法）
+ (void)cj_slideAnimateView:(UIView *)animatedView
                    forShow:(BOOL)forShow
           withShowDirection:(CJSlideFromDirection)showFromDirection
               animateOffset:(CGFloat)animateOffset
                  completion:(void (^ __nullable)(BOOL finished))completion
{
    NSArray<CJSlideInterceptor> *instanceInterceptors = animatedView.slideInterceptors;
    NSArray<CJSlideInterceptor> *globalInterceptors = _globalSlideInterceptors ?: @[];
    
    NSMutableArray<CJSlideInterceptor> *allInterceptors = [NSMutableArray array];
    if (instanceInterceptors.count > 0) {
        [allInterceptors addObjectsFromArray:instanceInterceptors];
    }
    if (globalInterceptors.count > 0) {
        [allInterceptors addObjectsFromArray:globalInterceptors];
    }
    
    if (allInterceptors.count == 0) {
        [self cj_slideAnimateView_default:animatedView
                                  forShow:forShow
                        withShowDirection:showFromDirection
                            animateOffset:animateOffset
                               completion:completion];
        return;
    }
    
    void(^chain)(NSInteger index) = nil;
    
    chain = ^(NSInteger index) {
        if (index >= allInterceptors.count) {
            [self cj_slideAnimateView_default:animatedView
                                      forShow:forShow
                            withShowDirection:showFromDirection
                                animateOffset:animateOffset
                                   completion:completion];
            return;
        }
        
        CJSlideInterceptor interceptor = allInterceptors[index];
        interceptor(animatedView, forShow, showFromDirection, animateOffset, ^{
            chain(index + 1);
        });
    };
    
    chain(0);
}

+ (void)cj_slideAnimateView_default:(UIView *)animatedView
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
    NSArray<CJSlide3DInterceptor> *instanceInterceptors = animatedView.slide3DInterceptors;
    NSArray<CJSlide3DInterceptor> *globalInterceptors = _globalSlide3DInterceptors ?: @[];
    
    NSMutableArray<CJSlide3DInterceptor> *allInterceptors = [NSMutableArray array];
    if (instanceInterceptors.count > 0) {
        [allInterceptors addObjectsFromArray:instanceInterceptors];
    }
    if (globalInterceptors.count > 0) {
        [allInterceptors addObjectsFromArray:globalInterceptors];
    }
    
    if (allInterceptors.count == 0) {
        [self cj_slide3DAnimateView_default:animatedView
                                    forShow:forShow
                          withShowDirection:showFromDirection
                              animateOffset:animateOffset
                                rotateAngle:rotateAngle
                                 completion:completion];
        return;
    }
    
    void(^chain)(NSInteger index) = nil;
    
    chain = ^(NSInteger index) {
        if (index >= allInterceptors.count) {
            [self cj_slide3DAnimateView_default:animatedView
                                        forShow:forShow
                              withShowDirection:showFromDirection
                                  animateOffset:animateOffset
                                    rotateAngle:rotateAngle
                                     completion:completion];
            return;
        }
        
        CJSlide3DInterceptor interceptor = allInterceptors[index];
        interceptor(animatedView, forShow, showFromDirection, animateOffset, rotateAngle, ^{
            chain(index + 1);
        });
    };
    
    chain(0);
}

+ (void)cj_slide3DAnimateView_default:(UIView *)animatedView
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

#pragma mark - 全局拦截器
@implementation UIView (CJSlideTransformGlobalInterceptor)

+ (void)addSlideInterceptor:(CJSlideInterceptor)interceptor {
    if (!_globalSlideInterceptors) {
        _globalSlideInterceptors = [NSMutableArray array];
    }
    [_globalSlideInterceptors addObject:[interceptor copy]];
}

+ (void)removeSlideInterceptor:(CJSlideInterceptor)interceptor {
    [_globalSlideInterceptors removeObject:interceptor];
}

+ (void)removeAllSlideInterceptors {
    [_globalSlideInterceptors removeAllObjects];
}

+ (void)addSlide3DInterceptor:(CJSlide3DInterceptor)interceptor {
    if (!_globalSlide3DInterceptors) {
        _globalSlide3DInterceptors = [NSMutableArray array];
    }
    [_globalSlide3DInterceptors addObject:[interceptor copy]];
}

+ (void)removeSlide3DInterceptor:(CJSlide3DInterceptor)interceptor {
    [_globalSlide3DInterceptors removeObject:interceptor];
}

+ (void)removeAllSlide3DInterceptors {
    [_globalSlide3DInterceptors removeAllObjects];
}

@end

#pragma mark - 实例拦截器
@implementation UIView (CJSlideTransformInstanceInterceptor)

- (NSArray<CJSlideInterceptor> *)slideInterceptors {
    return objc_getAssociatedObject(self, @selector(slideInterceptors));
}

- (void)setSlideInterceptors:(NSArray<CJSlideInterceptor> *)slideInterceptors {
    objc_setAssociatedObject(self, @selector(slideInterceptors), slideInterceptors, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSArray<CJSlide3DInterceptor> *)slide3DInterceptors {
    return objc_getAssociatedObject(self, @selector(slide3DInterceptors));
}

- (void)setSlide3DInterceptors:(NSArray<CJSlide3DInterceptor> *)slide3DInterceptors {
    objc_setAssociatedObject(self, @selector(slide3DInterceptors), slide3DInterceptors, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)addInstanceSlideInterceptor:(CJSlideInterceptor)interceptor {
    NSMutableArray *interceptors = [NSMutableArray arrayWithArray:self.slideInterceptors ?: @[]];
    [interceptors addObject:[interceptor copy]];
    self.slideInterceptors = interceptors;
}

- (void)removeInstanceSlideInterceptor:(CJSlideInterceptor)interceptor {
    NSMutableArray *interceptors = [NSMutableArray arrayWithArray:self.slideInterceptors ?: @[]];
    [interceptors removeObject:interceptor];
    self.slideInterceptors = interceptors;
}

- (void)removeAllInstanceSlideInterceptors {
    self.slideInterceptors = @[];
}

- (void)addInstanceSlide3DInterceptor:(CJSlide3DInterceptor)interceptor {
    NSMutableArray *interceptors = [NSMutableArray arrayWithArray:self.slide3DInterceptors ?: @[]];
    [interceptors addObject:[interceptor copy]];
    self.slide3DInterceptors = interceptors;
}

- (void)removeInstanceSlide3DInterceptor:(CJSlide3DInterceptor)interceptor {
    NSMutableArray *interceptors = [NSMutableArray arrayWithArray:self.slide3DInterceptors ?: @[]];
    [interceptors removeObject:interceptor];
    self.slide3DInterceptors = interceptors;
}

- (void)removeAllInstanceSlide3DInterceptors {
    self.slide3DInterceptors = @[];
}

@end
