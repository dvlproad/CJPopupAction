//
//  CJExpandCalculator.h
//  CJPopupAction
//
//  Created by ciyouzen on 2026/7/25.
//
//  弹窗动画的位置计算器，提供两类动画的位置计算：
//  1. 位移动画（Slide）：通过 CGAffineTransform 实现，视图从屏幕边缘滑入
//  2. 展开动画（Expand）：通过 frame 变化实现，视图从某个锚点展开到目标大小
//
//  展开动画（Expand）特点：
//  - 动画区域始终在 showFrame 的范围内
//  - hideFrame 是 showFrame 的子集（点或线）
//  - showFrame 定义了动画的最终目标和边界
//  - direction 决定了动画从 showFrame 的哪个边缘/点开始

#import <Foundation/Foundation.h>

/// 展开动画的方向（仅支持上下和居中，左右请直接调用 expandToLeft/Right 方法）
/// 展开动画特点：动画区域始终在 showFrame 范围内，hideFrame 是 showFrame 的子集
typedef NS_ENUM(NSUInteger, CJExpandToDirection) {
    CJExpandToDirectionDown = 0,     // 向下展开（上边固定，如：下拉菜单）
    CJExpandToDirectionUp,           // 向上展开（下边固定，如：按钮上方弹出）
    CJExpandToDirectionCenter,       // 向四周展开（中心固定，如：居中弹窗）
};


@interface CJExpandCalculator : NSObject {
    
}

#pragma mark - 计算 showFrame
/// 从指定点向下展开：传左上角（如：下拉菜单）
/// @param leftTop 展开动画的左上角起点
/// @param size 展开后的目标大小
/// @return showFrame 定义了动画的最终目标和边界
+ (CGRect)showFrameFromLeftTop:(CGPoint)leftTop size:(CGSize)size;

/// 从指定点向上展开：传左下角（如：按钮上方弹出）
/// @param leftBottom 展开动画的左下角起点
/// @param size 展开后的目标大小
/// @return showFrame 定义了动画的最终目标和边界
+ (CGRect)showFrameFromLeftBottom:(CGPoint)leftBottom size:(CGSize)size;

/// 从指定点向四周展开：传中心点（如：居中弹窗）
/// @param center 展开动画的中心起点
/// @param size 展开后的目标大小
/// @return showFrame 定义了动画的最终目标和边界
+ (CGRect)showFrameFromCenter:(CGPoint)center size:(CGSize)size;

#pragma mark - 计算 hideFrame
/// 根据 showFrame 和 direction 计算 hideFrame
/// 展开动画特点：hideFrame 是 showFrame 的子集（点或线）
/// @param showFrame 展开后的目标frame（动画的最终目标）
/// @param direction 展开方向（决定动画从 showFrame 的哪个边缘/点开始）
/// @return hideFrame 动画的起始frame（在 showFrame 范围内）
+ (CGRect)hideFrameFromShowFrame:(CGRect)showFrame
                       direction:(CJExpandToDirection)direction;

@end
