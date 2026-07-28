//
//  UIView+CJExpandFrameAnimationBind.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//
//  展开动画进阶：show时记录参数到view，hide时复用，简化调用

#import "UIView+CJExpandFrameAnimation.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 展开动画（进阶）
@interface UIView (CJExpandFrameAnimationBind)

+ (void)cj_showExpandAnimateBindView:(UIView *)animatedView
                        withShowFrame:(CGRect)showFrame
                            direction:(CJExpandToDirection)direction
                            blankView:(nullable UIView *)blankView
                           completion:(void(^)(void))completion;
+ (void)cj_hideExpandAnimateBindView:(UIView *)animatedView
                           completion:(void(^)(void))completion;

@end

#pragma mark - View Properties
@interface UIView (CJExpandFrameAnimationBindProperty)

@property (nonatomic, assign) CGRect cjExpandShowFrame;  /**< show时记录显示frame，hide时复用 */
@property (nonatomic, assign) CJExpandToDirection cjExpandDirection;  /**< show时记录展开方向，hide时复用 */
@property (nonatomic, strong, nullable) UIView *cjExpandBlankView;  /**< show时记录blankView，hide时复用 */

@end

NS_ASSUME_NONNULL_END
