//
//  UIView+CJBottomInWindow.h
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
#import <objc/runtime.h>
#import "UIView+CJExpandAnimation.h"
#import "UIView+CJSlideAnimation.h"

NS_ASSUME_NONNULL_BEGIN


@interface UIView (CJExpandByPoint) {
    
}
/**
 *  将当前视图弹出到window底部
 *
 *  @param animated                    弹出时候的时候是否需要动画
 *  @param popupViewHeight             弹出视图的高度
 *  @param edgeInsets                  弹窗与window的(左右下)边距
 *  @param blankView                   空白遮罩视图（nil则使用默认遮罩，frame由内部自动设置为window大小）
 *  @param showPopupViewCompleteBlock  显示弹出视图后的操作
 *  @param tapBlankViewCompleteBlock   点击空白区域后的操作(要自己执行cj_hideFromBottomWindow...来隐藏，因为有时候点击背景是不执行隐藏的)
 */
- (void)cj_showInBottomWindow:(BOOL)animated
                   withHeight:(CGFloat)popupViewHeight
                   edgeInsets:(UIEdgeInsets)edgeInsets
                    blankView:(nullable UIView *)blankView
                 showComplete:(void(^)(void))showPopupViewCompleteBlock
             tapBlankComplete:(void(^)(void))tapBlankViewCompleteBlock;

#pragma mark - 隐藏

/**
 *  隐藏弹出视图
 */
- (void)cj_hideFromBottomWindow:(BOOL)animated;

@end


NS_ASSUME_NONNULL_END
