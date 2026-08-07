//
//  CQTSBlankPresenter.h
//  CQDemoKit
//
//  Created by ciyouzen on 2026/08/04.
//

#import <Foundation/Foundation.h>
#import "CQTSBlankViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/*
 *  弹窗空白视图(blankView)的展示者（负责"怎么弹"，默认实现）
 *  @brief 把 blankView 加到 blankSuperview 上，并调用其布局契约
 *         updateConstraintsForPopupViewWithShow: 来显示/隐藏其中的 popupView，
 *         完成 0.3s 滑动动画。展示者只依赖布局契约 CQTSBlankViewProtocol，
 *         不感知具体容器类型。
 */
@interface CQTSBlankPresenter : NSObject

/*
 *  显示最完整弹窗视图blankView
 *
 *  @param blankView            要显示的含点击背景的最完整弹窗视图blankView
 *  @param blankSuperview       要显示在什么视图上(为nil时候，显示在keyWindow上)
 *  @param showComplete         显示动画完成的回调
 */
- (void)showBlankView:(UIView<CQTSBlankViewProtocol> *)blankView
               inView:(nullable UIView *)blankSuperview
             complete:(void(^ _Nullable)(void))showComplete;

/*
 *  隐藏最完整弹窗视图blankView
 *  @note  隐藏幂等，允许"一次 show 后多次调用 hideBlankView"而不崩溃
 *
 *  @param blankView            要隐藏的含点击背景的最完整弹窗视图blankView
 */
- (void)hideBlankView:(UIView<CQTSBlankViewProtocol> *)blankView;

@end

NS_ASSUME_NONNULL_END
