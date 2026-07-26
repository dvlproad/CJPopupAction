//
//  UIView+CJSlideAnimation.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJSlideAnimation.h"
#import <objc/runtime.h>

@implementation UIView (CJSlideAnimation)


#pragma mark - Runtime: Assign
- (CJSlideFromDirection)cjShowFromDirection {
    return [objc_getAssociatedObject(self, @selector(cjShowFromDirection)) integerValue];
}

- (void)setCjShowFromDirection:(CJSlideFromDirection)cjShowFromDirection {
    objc_setAssociatedObject(self, @selector(cjShowFromDirection), @(cjShowFromDirection), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - 普通平移

/*
 *  添加从哪个方向进来的动画(变化过程透明度会从0到1)
 *
 *  @param forShow              显示还是隐藏
 *  @param showFromDirection    如果是显示的话，是从哪个方向进来的(关闭的时候回到对应的方向)
 *  @param animateOffset        移动的距离（正数）
 *  @param completion           动画结束的回调
 */
- (void)cj_slideAnimateForShow:(BOOL)forShow
             withShowDirection:(CJSlideFromDirection)showFromDirection
                 animateOffset:(CGFloat)animateOffset
                    completion:(void (^ __nullable)(BOOL finished))completion
{
    [self.superview layoutIfNeeded]; // 确保在使用如mas_makeConstraints的时候能够立马生成约束

    /*
    [UIView animateWithDuration:0.3f delay:3.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        [self mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(cell.mas_top).mas_offset(-animateOffset);
//        }];
//        [self.superview layoutIfNeeded];
        self.transform = CGAffineTransformIdentity;
        
    } completion:nil];
     */
    
    if (forShow) {
        [self __updateTransformFromDirection:showFromDirection animateOffset:animateOffset];
        
        self.alpha = 0;
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
            self.alpha = 1;
            
        } completion:completion];
    } else {
        self.transform = CGAffineTransformIdentity;
        
        self.alpha = 1;
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self __updateTransformFromDirection:showFromDirection animateOffset:animateOffset];
            self.alpha = 0;
            
        } completion:completion];
    }
}


#pragma mark - 3D平移(有旋转角度时，带旋转效果；无旋转角度即为0时，等价于普通平移)
/*
 *  带旋转的位移动画(3D transform)
 *
 *  @param forShow              显示还是隐藏
 *  @param showFromDirection    如果是显示的话，是从哪个方向进来的(关闭的时候回到对应的方向)
 *  @param animateOffset        移动的距离（正数）
 *  @param rotateAngle          旋转角度（弧度），0 = 不旋转，为0是效果等价于上述的平移方法
 *  @param completion           动画结束的回调
 */
- (void)cj_3DSlideAnimateForShow:(BOOL)forShow
               withShowDirection:(CJSlideFromDirection)showFromDirection
                   animateOffset:(CGFloat)animateOffset
                     rotateAngle:(CGFloat)rotateAngle
                      completion:(void (^ __nullable)(BOOL finished))completion
{
    [self.superview layoutIfNeeded];

    // 旋转轴：绕Z轴旋转（垂直屏幕的轴），根据方向决定旋转正负
    CGFloat zAxis = (showFromDirection == CJSlideFromDirectionLeft ||
                     showFromDirection == CJSlideFromDirectionTop) ? 1.0 : -1.0;

    CATransform3D hideTransform3D = [self __updateTransform3DFromDirection:showFromDirection
                                                            animateOffset:animateOffset
                                                               rotateAngle:rotateAngle
                                                                    zAxis:zAxis];

    if (forShow) {
        self.layer.transform = hideTransform3D;
        self.alpha = 0;
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.layer.transform = CATransform3DIdentity;
            self.alpha = 1;
        } completion:completion];
    } else {
        self.layer.transform = CATransform3DIdentity;
        self.alpha = 1;
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.layer.transform = hideTransform3D;
            self.alpha = 0;
        } completion:completion];
    }
}


#pragma mark - Private Method
/*
 *  更新当前视图的位置到当前位置的direction方向上距离animateOffset的位置
 *
 *  @param direction direction
 *  @param animateOffset animateOffset
 */
- (void)__updateTransformFromDirection:(CJSlideFromDirection)direction
                         animateOffset:(CGFloat)animateOffset
{
    CGAffineTransform transform;
    if (direction == CJSlideFromDirectionTop) {              // 向上移动
        transform = CGAffineTransformMakeTranslation(0, -animateOffset);
    } else if (direction == CJSlideFromDirectionBottom) {    // 向下移动
        transform = CGAffineTransformMakeTranslation(0, animateOffset);
    } else if (direction == CJSlideFromDirectionLeft) {
        transform = CGAffineTransformMakeTranslation(-animateOffset, 0);
    } else if (direction == CJSlideFromDirectionRight) {
        transform = CGAffineTransformMakeTranslation(animateOffset, 0);
    } else {
        transform = CGAffineTransformMakeTranslation(0, animateOffset);
    }
    
    self.transform = transform;
}

/*
 *  更新当前视图的3D变换到指定方向、偏移和旋转
 *
 *  @param direction direction
 *  @param animateOffset animateOffset
 *  @param rotateAngle rotateAngle (弧度)
 *  @param zAxis 旋转轴Z值，1.0或-1.0
 */
- (CATransform3D)__updateTransform3DFromDirection:(CJSlideFromDirection)direction
                                    animateOffset:(CGFloat)animateOffset
                                       rotateAngle:(CGFloat)rotateAngle
                                            zAxis:(CGFloat)zAxis
{
    // 先平移
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

    // 再旋转（绕Z轴）
    CATransform3D rotate = CATransform3DMakeRotation(rotateAngle, 0.0, 0.0, zAxis);

    return CATransform3DConcat(rotate, translate);
}

@end
