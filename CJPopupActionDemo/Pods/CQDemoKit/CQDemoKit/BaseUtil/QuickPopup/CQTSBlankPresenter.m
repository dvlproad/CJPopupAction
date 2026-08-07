//
//  CQTSBlankPresenter.m
//  CQDemoKit
//
//  Created by ciyouzen on 2026/08/04.
//

#import "CQTSBlankPresenter.h"

#import <Masonry/Masonry.h>

@implementation CQTSBlankPresenter

/*
 *  显示最完整弹窗视图blankView
 *
 *  @param blankView            要显示的含点击背景的最完整弹窗视图blankView
 *  @param blankSuperview       要显示在什么视图上(为nil时候，显示在keyWindow上)
 *  @param showComplete         显示动画完成的回调
 */
- (void)showBlankView:(UIView<CQTSBlankViewProtocol> *)blankView
               inView:(nullable UIView *)blankSuperview
             complete:(void(^ _Nullable)(void))showComplete {
    if (blankSuperview == nil) {
        blankSuperview = [[UIApplication sharedApplication] keyWindow];
    }
    [blankSuperview addSubview:blankView];
    [blankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(blankSuperview);
    }];
    [blankView layoutIfNeeded];
    
    [blankView updateConstraintsForPopupViewWithShow:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [blankView layoutIfNeeded];
    } completion:^(BOOL finished) {
        !showComplete ?: showComplete();
    }];
}

/*
 *  隐藏最完整弹窗视图blankView
 *  @note  隐藏幂等，允许"一次 show 后多次调用 hideBlankView"而不崩溃
 *
 *  @param blankView            要隐藏的含点击背景的最完整弹窗视图blankView
 */
- (void)hideBlankView:(UIView<CQTSBlankViewProtocol> *)blankView {
    if (blankView.superview == nil) {
        return;   // 幂等：第二次调用时 superview 为 nil，安全跳过
    }
    // 注意：当正在关闭弹窗的时候，应该禁用整个视图的所有点击（防止尤其是当关闭耗时时候，多次进行的空白区域的快速点击导致重复调用）
    blankView.userInteractionEnabled = NO;
    
    [blankView updateConstraintsForPopupViewWithShow:NO];
    [UIView animateWithDuration:0.3 animations:^{
        [blankView layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (blankView.superview != nil) {
            [blankView removeFromSuperview];
        }
    }];
}

@end
