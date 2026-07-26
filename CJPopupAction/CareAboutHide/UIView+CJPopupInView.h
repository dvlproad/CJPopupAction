//
//  UIView+CJPopupInView.h
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

#define CJPopupMainThreadAssert() NSAssert([NSThread isMainThread], @"UIView+CJPopupInView needs to be accessed on the main thread.");

typedef void(^CJTapBlankViewCompleteBlock)(void);

@interface UIView (CJPopupInView) {
    
}
@property (nonatomic, strong) UIView *cjShowInView; /**< 弹出视图被add到的view */
@property (nonatomic, assign, getter=isCJPopupViewShowing) BOOL cjPopupViewShowing;   /**< 判断当前是否有弹出视图显示 */
@property (nonatomic, strong) UIView *cjTapView;    /**< 空白区域（指radioButtons组合下的点击区域（不包括radioButtons区域），用来点击之后隐藏列表） */
@property (nonatomic, copy) NSString *cjPopupViewHideFrameString;   /**< 弹出视图隐藏时候的frame */

@property (nonatomic, copy) void(^cjTapBlankViewCompleteBlock)(void);   /**< 点击空白区域执行的操作 */
@property (nonatomic, copy) void(^cjShowPopupViewCompleteBlock)(void);  /**< 显示弹出视图后的操作 */

/**
 *  将popupView添加进keyWindow中(会默认添加进blankView及对popupView做一些默认设置)
 *
 *  @param popupView                要被添加的视图
 *  @param blankView                空白遮罩视图（nil则不添加遮罩，frame由内部自动设置）
 *
 *  @return 是否可以被添加成功
 */
- (BOOL)letkeyWindowAddPopupView:(UIView *)popupView
                       blankView:(nullable UIView *)blankView;

/**
 *  将popupView添加进popupSuperview中(会默认添加进blankView及对popupView做一些默认设置)
 *
 *  @param popupSuperview           被添加到的地方
 *  @param popupView                要被添加的视图
 *  @param blankView                空白遮罩视图（nil则不添加遮罩，frame由内部自动设置为popupSuperview.bounds）
 *
 *  @return 是否可以被添加成功
 */
- (BOOL)letPopupSuperview:(UIView *)popupSuperview
             addPopupView:(UIView *)popupView
                blankView:(nullable UIView *)blankView;

@end


NS_ASSUME_NONNULL_END
