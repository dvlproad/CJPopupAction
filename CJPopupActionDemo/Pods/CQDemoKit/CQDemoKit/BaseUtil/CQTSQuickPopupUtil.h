//
//  CQTSQuickPopupUtil.h
//  CQDemoKit
//
//  Created by ciyouzen on 2026/08/04.
//

#import <UIKit/UIKit.h>

@class CQTSBottomBlankView;
@class CQTSCenterBlankView;

NS_ASSUME_NONNULL_BEGIN

@interface CQTSQuickPopupUtil : NSObject

/*
 *  创建并显示【底部弹窗】在 keyWindow 上（自定义内容视图直接作为内容，无下拉线、无模糊圆角）
 *  @brief 默认：点击空白区域自动隐藏；无毛玻璃效果；无下拉手势
 *
 *  @param contentView          弹出视图的内容视图
 *  @param popupViewHeight      弹出视图的高度
 *  @param tapBlankComplete     点击空白区域要执行的操作（如 [bBlankView hideBlankView]）
 *
 *  @return 显示中的容器视图（可持有，用于之后调用 hideBlankView 隐藏）
 */
+ (nullable CQTSBottomBlankView *)showWindowBottomClearView:(UIView *)contentView
                                                     height:(CGFloat)popupViewHeight
                                           tapBlankComplete:(void(^ _Nullable)(CQTSBottomBlankView *bBlankView))tapBlankComplete;

/*
 *  创建并显示【中心弹窗】在 keyWindow 上（自定义内容视图直接作为内容，无模糊圆角）
 *  @brief 点击空白区域是否隐藏由 tapBlankDismiss 决定；显示位置可通过 popupCenterOffset 调整
 *
 *  @param contentView           弹出视图的内容视图
 *  @param popupViewSize         弹出视图的大小
 *  @param tapBlankComplete      点击空白区域要执行的操作（如 [bBlankView hideBlankView]）
 *
 *  @return 显示中的容器视图（可持有，用于之后调用 hideBlankView 隐藏）
 */
+ (nullable CQTSCenterBlankView *)showWindowCenterClearView:(UIView *)contentView
                                                       size:(CGSize)popupViewSize
                                           tapBlankComplete:(void(^ _Nullable)(CQTSCenterBlankView *bBlankView))tapBlankComplete;

@end

NS_ASSUME_NONNULL_END
