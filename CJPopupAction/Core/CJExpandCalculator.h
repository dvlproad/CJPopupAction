//
//  CJExpandCalculator.h
//  CJPopupAction
//
//  Created by ciyouzen on 2026/7/25.
//
//  弹窗动画的位置计算器，提供两类动画的位置计算：
//  1. 位移动画（Slide）：通过 CGAffineTransform 实现，视图从屏幕边缘滑入
//  2. 展开动画（Expand）：通过 frame 变化实现，视图从某个锚点展开到目标大小

#import <UIKit/UIKit.h>

/// 展开动画的方向（仅支持上下和居中，左右请直接调用 expandToLeft/Right 方法）
typedef NS_ENUM(NSUInteger, CJExpandToDirection) {
    CJExpandToDirectionDown = 0,     // 向下展开（上边固定，如：下拉菜单）
    CJExpandToDirectionUp,           // 向上展开（下边固定，如：按钮上方弹出）
    CJExpandToDirectionCenter,       // 向四周展开（中心固定，如：居中弹窗）
};


@interface CJExpandCalculator : NSObject {
    
}

typedef struct {
    CGRect showFrame;
    CGRect hideFrame;
} CJExpandFramePair;

/// 从指定点向下展开：传左上角（如：下拉菜单）
+ (CJExpandFramePair)expandToDownFromLeftTop:(CGPoint)leftTop size:(CGSize)size;

/// 从指定点向上展开：传左下角（如：按钮上方弹出）
+ (CJExpandFramePair)expandToUpFromLeftBottom:(CGPoint)leftBottom size:(CGSize)size;
/*
/// 从指定点向右展开：传左上角
+ (CJExpandFramePair)expandToRightFromLeftTop:(CGPoint)leftTop size:(CGSize)size;

/// 从指定点向左展开：传右上角
+ (CJExpandFramePair)expandToLeftFromRightTop:(CGPoint)rightTop size:(CGSize)size;
*/
/// 从指定点向四周展开：传中心点（如：居中弹窗）
+ (CJExpandFramePair)expandToCenterFromCenter:(CGPoint)center size:(CGSize)size;


@end
