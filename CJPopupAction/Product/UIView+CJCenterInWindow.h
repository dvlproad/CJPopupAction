//
//  UIView+CJCenterInWindow.h
//  CJPopupAction
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//
//  动画类型说明：
//  本库提供两类动画，核心区别：位移 = 大小不变，位置变了（"推过来"）；展开 = 位置锚定，大小变了（"长出来"）
//
//  1. 位移动画（Slide）：通过 CGAffineTransform 实现，视图大小不变，位置从某处平移到目标位置
//     从下向上：Action Sheet、底部工具栏、分享面板
//     从上向下：通知横幅、下拉提示条
//     从左向右：侧边栏菜单
//     从右向左：右侧抽屉、聊天消息气泡进入
//
//  2. 展开动画（Expand）：通过 frame 变化实现，视图从某个锚点展开到目标大小
//     向下展开：下拉菜单、筛选列表（从触发位置向下"拉"出）
//     向上展开：按钮上方弹出菜单、日期选择器（从触发位置向上"推"出）
//     向四周展开：居中弹窗、确认对话框（从中心点向四周"长"出）

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// popupInCenterWindow 时候的动画类型
typedef NS_ENUM(NSUInteger, CJCenterWindowAnimationType) {
    CJCenterWindowAnimationTypeNone = 0,        // 不需要动画
    CJCenterWindowAnimationTypeExpandToCenter,  // 从中心展开的【展开动画】
    CJCenterWindowAnimationTypeSlideToCenter,   // 从屏幕外平移飞入中心的【位移动画】
    CJCenterWindowAnimationType3DSlideToCenter, // 从屏幕外旋转飞入中心的【位移动画】
};

@interface UIView (CJPopupInCenterWindow) {
    
}
/**
 *  将当前视图弹出到window中央
 *
 *  @param animationType                弹出时候的动画采用的类型
 *  @param popupViewSize                弹出视图的大小
 *  @param blankBGColor                 空白区域的自定义背景颜色
 *  @param showPopupViewCompleteBlock   显示弹出视图后的操作
 *  @param tapBlankViewCompleteBlock    点击空白区域后的操作(要自己执行cj_hidePopupView...来隐藏，因为有时候点击背景是不执行隐藏的)
 */
- (void)cj_popupInCenterWindow:(CJCenterWindowAnimationType)animationType
                      withSize:(CGSize)popupViewSize
                  blankBGColor:(nullable UIColor *)blankBGColor
                  showComplete:(void(^)(void))showPopupViewCompleteBlock
              tapBlankComplete:(void(^)(void))tapBlankViewCompleteBlock;

#pragma mark - 隐藏

/**
 *  隐藏弹出视图
 */
- (void)cj_centerHidePopupView:(BOOL)animated;

@end


NS_ASSUME_NONNULL_END
