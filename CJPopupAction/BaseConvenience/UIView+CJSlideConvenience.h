//
//  UIView+CJSlideConvenience.h
//  CJPopupAction
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//
//  位移动画便捷方法：自动计算距离、小距离动画

#import <UIKit/UIKit.h>
#import "CJSlideCalculator.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CJSlideConvenience)

/// 从window指定方向进来的动画（自动计算到窗口边缘的距离）
/// @param direction 从哪个方向进来
- (void)cq_slideFromWindowDirection:(CJSlideFromDirection)direction;

/// 小距离从指定方向进来的动画
/// @param offset 移动的距离
/// @param showFromDirection 从哪个方向进来
- (void)cq_slideFromOffset:(CGFloat)offset
                 direction:(CJSlideFromDirection)showFromDirection;

/// 小距离离开的动画（使用记住的方向）
/// @param animate 是否需要动画
- (void)cq_slideSmallForHideWithAnimate:(BOOL)animate;

@end

NS_ASSUME_NONNULL_END
