//
//  UIView+CJSlideAnimation.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJSlideCalculator.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CJSlideAnimationType) {
    CJSlideAnimationTypeNone = 0,   // 无平移效果，直接显示
    CJSlideAnimationTypeNormal,     // 普通平移
    CJSlideAnimationType3D,         // 3D 平移
};

@interface UIView (CJSlideAnimation) {
    
}
@property (nonatomic, assign) CJSlideFromDirection cjShowFromDirection;  /**< 如果是显示的话，是从哪个方向进来的(关闭的时候回到对应的方向) */

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
                    completion:(void (^ __nullable)(BOOL finished))completion;


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
                      completion:(void (^ __nullable)(BOOL finished))completion;

@end

NS_ASSUME_NONNULL_END
