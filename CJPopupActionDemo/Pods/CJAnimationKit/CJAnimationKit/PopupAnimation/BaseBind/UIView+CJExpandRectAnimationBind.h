//
//  UIView+CJExpandRectAnimationBind.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//
//  展开动画进阶：show时记录参数到view，hide时复用，简化调用

#import "UIView+CJExpandRectAnimation.h"
#import "CJExpandCalculator.h"   // 需要 CJExpandToDirection

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 展开动画（进阶）
@interface UIView (CJExpandRectAnimationBind)

/// 便捷方法：frame 驱动，show 时记录参数到 view，hide 时复用（内部翻译成 block），
/// 适合非 AutoLayout 的 frame 布局场景
+ (void)cj_showExpandAnimateBindView:(UIView *)animatedView
                        withShowFrame:(CGRect)showFrame
                            direction:(CJExpandToDirection)direction
                            blankView:(nullable UIView *)blankView
                           completion:(nullable void(^)(void))completion;
/// 核心方法：block 驱动，show 时记录 block 到 view，hide 时复用，block 内设置显示/隐藏状态（通常通过修改约束实现）
+ (void)cj_showExpandAnimateBindView:(UIView *)animatedView
                         animateBlock:(CJExpandAnimateBlock)animateBlock
                           completion:(nullable void(^)(void))completion;
+ (void)cj_hideExpandAnimateBindView:(UIView *)animatedView
                           completion:(nullable void(^)(void))completion;

@end

#pragma mark - View Properties
@interface UIView (CJExpandRectAnimationBindProperty)

@property (nonatomic, copy, nullable) CJExpandAnimateBlock cjExpandAnimateBlock;  /**< show时记录animateBlock，hide时复用 */

@end

NS_ASSUME_NONNULL_END
