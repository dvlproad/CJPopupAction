//
//  CJPopupCalculator.h
//  CJPopupAction
//
//  Created by ciyouzen on 2026/7/25.
//
//  弹窗动画的位置计算器，提供两类动画的位置计算：
//  1. 位移动画（Slide）：通过 CGAffineTransform 实现，视图从屏幕边缘滑入
//  2. 展开动画（Expand）：通过 frame 变化实现，视图从某个锚点展开到目标大小

#import <UIKit/UIKit.h>

/// 位移方向：视图从哪个方向滑入
typedef NS_ENUM(NSUInteger, CJSlideFromDirection) {
    CJSlideFromDirectionTop = 0,       // 从上方滑入（向下移动）
    CJSlideFromDirectionBottom,        // 从下方滑入（向上移动）
    CJSlideFromDirectionLeft,          // 从左侧滑入（向右移动）
    CJSlideFromDirectionRight,         // 从右侧滑入（向左移动）
};


@interface CJPopupCalculator : NSObject

typedef struct {
    CGRect showFrame;
    CGRect hideFrame;
} CJPopupFramePair;

+ (CGAffineTransform)slideHideTransformWithDirection:(CJSlideFromDirection)direction
                                             offset:(CGFloat)offset;

/// 从指定点向下展开：传左上角（如：下拉菜单）
+ (CJPopupFramePair)expandToDownFromTopLeft:(CGPoint)topLeft size:(CGSize)size;

/// 从指定点向上展开：传左下角（如：按钮上方弹出）
+ (CJPopupFramePair)expandToUpFromBottomLeft:(CGPoint)bottomLeft size:(CGSize)size;

/// 从指定点向右展开：传左上角
+ (CJPopupFramePair)expandToRightFromTopLeft:(CGPoint)topLeft size:(CGSize)size;

/// 从指定点向左展开：传右上角
+ (CJPopupFramePair)expandToLeftFromTopRight:(CGPoint)topRight size:(CGSize)size;

/// 从指定点向四周展开：传中心点（如：居中弹窗）
+ (CJPopupFramePair)expandToCenterFromCenter:(CGPoint)center size:(CGSize)size;

@end
