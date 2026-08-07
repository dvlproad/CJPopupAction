//
//  UIView+CJExpandRectAnimation.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//
//  展开动画：不一定需要blankView

#import <UIKit/UIKit.h>
#import "UIView+CJExpandInterceptor.h"   // 需要 CJExpandAnimateBlock、CJExpandInterceptor

static CGFloat kCJPopupAnimationDuration = 0.3;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 类方法
@interface UIView (CJExpandRectAnimation)

/// 核心方法：block 驱动展开动画，block 内设置视图显示/隐藏状态（通常通过修改约束实现）
/// 动画层只负责 animateWithDuration + layoutIfNeeded，分两阶段执行：
/// 先设置初始状态（!forShow）并立即布局，再动画到目标状态（forShow）
+ (void)cj_expandAnimateView:(UIView *)animatedView
                      forShow:(BOOL)forShow
                  animateBlock:(CJExpandAnimateBlock)animateBlock
                    completion:(nullable void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
