//
//  UIView+CJSlideTransformAnimationBind.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//
//  位移动画进阶：show时记录参数到view，hide时复用，简化调用

#import "UIView+CJSlideTransformAnimation.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CJSlideTransformAnimationBind)

#pragma mark - 普通平移（进阶）
+ (void)cj_showSlideAnimateBindView:(UIView *)animatedView
                    withShowDirection:(CJSlideFromDirection)showFromDirection
                        animateOffset:(CGFloat)animateOffset
                           completion:(void (^ __nullable)(BOOL finished))completion;
+ (void)cj_hideSlideAnimateBindView:(UIView *)animatedView
                          completion:(void (^ __nullable)(BOOL finished))completion;

#pragma mark - 3D平移（进阶）
+ (void)cj_show3DSlideAnimateBindView:(UIView *)animatedView
                    withShowDirection:(CJSlideFromDirection)showFromDirection
                        animateOffset:(CGFloat)animateOffset
                          rotateAngle:(CGFloat)rotateAngle
                           completion:(void (^ __nullable)(BOOL finished))completion;
+ (void)cj_hide3DSlideAnimateBindView:(UIView *)animatedView
                           completion:(void (^ __nullable)(BOOL finished))completion;

@end

#pragma mark - View Properties
@interface UIView (CJSlideTransformAnimationBindProperty)

@property (nonatomic, assign) CJSlideFromDirection cjShowFromDirection;  /**< show时记录方向，hide时复用 */
@property (nonatomic, assign) CGFloat cjAnimateOffset;  /**< show时记录移动距离，hide时复用 */
@property (nonatomic, assign) CGFloat cjRotateAngle;  /**< show时记录旋转角度，hide时复用 */

@end

NS_ASSUME_NONNULL_END
