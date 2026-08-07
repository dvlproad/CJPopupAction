//
//  CQTSCenterBlankView.h
//  CQDemoKit
//
//  Created by ciyouzen on 2026/08/04.
//

#import <UIKit/UIKit.h>
#import "CQTSBlankViewProtocol.h"

@class CQTSBlankPresenter;

NS_ASSUME_NONNULL_BEGIN

@interface CQTSCenterBlankView : UIView <CQTSBlankViewProtocol>

@property (nonatomic, strong, readonly) UIView *popupView;          /**< 弹出的内容视图 */
@property (nonatomic, assign, readonly) CGSize popupViewSize;       /**< 弹出的内容视图的大小 */
@property (nonatomic, assign, readonly) CGPoint popupCenterOffset;  /**< 弹出的内容视图相对容器中心的偏移量 */

#pragma mark - Init
/*
 *  初始化包含popupView的【中心完整弹出框视图】（内容视图居中显示在容器）
 *
 *  @param popupView            弹出视图的内容视图
 *  @param popupViewSize        弹出视图的大小
 *  @param popupCenterOffset    弹出视图相对容器中心的偏移量
 */
- (instancetype)initWithPopupView:(UIView *)popupView
                    popupViewSize:(CGSize)popupViewSize
                popupCenterOffset:(CGPoint)popupCenterOffset
                 tapBlankComplete:(void(^ _Nullable)(CQTSCenterBlankView *bBlankView))tapBlankComplete NS_DESIGNATED_INITIALIZER;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

#pragma mark - Popup
/*
 *  弹出策略（负责"怎么弹"，由本容器持有）
 *  @brief 显示前调用方需设置，隐藏通过它来执行（为nil时隐藏为无操作）
 */
@property (nonatomic, strong, nullable) CQTSBlankPresenter *blankPresenter;

#pragma mark - Show & Hide
/*
 *  显示弹窗（默认显示在 keyWindow 上，内部委托给 blankPresenter 执行）
 *
 *  @param blankSuperview  要显示在什么视图上（传 nil 表示 keyWindow）
 *  @param showComplete    显示动画完成的回调
 */
- (void)showBlankViewInView:(nullable UIView *)blankSuperview
                   complete:(void(^ _Nullable)(void))showComplete;

/*
 *  隐藏弹窗（幂等，可多次调用，内部委托给 blankPresenter 执行）
 */
- (void)hideBlankView;

#pragma mark - Get Method
/// 通过 popupView 获取到其所在的 popupView 容器，常用于 popupView 中的点击需要让容器隐藏等动作
+ (nullable CQTSCenterBlankView *)blankViewFromPopupView:(UIView *)popupView;

@end

NS_ASSUME_NONNULL_END
