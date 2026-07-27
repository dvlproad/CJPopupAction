//
//  UIView+CJBlankView.h
//  CJPopupAction
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 空白遮罩视图工厂方法
@interface UIView (CJBlankView)

/// 默认遮罩视图（rgba(0.16, 0.17, 0.21, 0.6)）
+ (UIView *)cj_defaultBlankView;

/// 指定颜色的遮罩视图
/// @param color 遮罩颜色
+ (UIView *)cj_blankViewWithColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
