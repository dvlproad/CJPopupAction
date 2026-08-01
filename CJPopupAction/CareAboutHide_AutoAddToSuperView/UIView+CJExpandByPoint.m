//
//  UIView+CJExpandByPoint.m
//  CJPopupAction
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJExpandByPoint.h"
#import "UIView+CJPopupInView.h"
#import "UIView+CJExpandFrameAnimationBind.h"
#import "UIView+CJSlideTransformAnimation.h"
#import "CJExpandCalculator.h"


@implementation UIView (CJExpandByPoint)

#pragma mark - 显示
/** 完整的描述请参见文件头部 */
- (void)cj_popupInView:(UIView *)popupSuperview
              animated:(BOOL)animated
            withOrigin:(CGPoint)popupViewOrigin
                  size:(CGSize)popupViewSize
             blankView:(nullable UIView *)blankView
          showComplete:(void(^)(void))showPopupViewCompleteBlock
      tapBlankComplete:(void(^)(void))tapBlankViewCompleteBlock
{
    CJPopupMainThreadAssert();
    
    // 1. 挂载popupView（内部完成blankView创建与挂载、frame设置、tapBlankComplete存储，无动画）
    BOOL canAdd = [self cj_mountInView:popupSuperview
                                withOrigin:popupViewOrigin
                                      size:popupViewSize
                                 blankView:blankView
                          tapBlankComplete:tapBlankViewCompleteBlock];
    if (!canAdd) {  // 挂载失败
        return;
    }
    
    // 2. 显示（动画）
    [self cj_showAnimateInView:animated
                  showComplete:showPopupViewCompleteBlock];
}

#pragma mark - 挂载popupView（无动画）
/** 完整的描述请参见文件头部 */
- (BOOL)cj_mountInView:(UIView *)popupSuperview
                withOrigin:(CGPoint)popupViewOrigin
                      size:(CGSize)popupViewSize
                 blankView:(nullable UIView *)blankView
          tapBlankComplete:(void(^)(void))tapBlankViewCompleteBlock
{
    CJPopupMainThreadAssert();
    
    UIView *popupView = self;
    
    // 1. 先设置 blankView 的frame：根据入参(popupSuperview/popupViewOrigin)确定其在 popupSuperview 中的位置与大小
    //    （兄弟模式下，popupView直接添加到popupSuperview，frame即popupSuperview坐标，无需换算）
    //    若没有创建 blankView(blankView==nil)，则不需要设置其frame。
    if (blankView != nil) {
        // 此处有设置，则blankBG的宽为popupSuperview满宽(下拉菜单，不必支持非popupSuperview满宽的情况，视觉体验不好)
        CGFloat blankViewY = popupViewOrigin.y;
        CGFloat blankViewHeight = CGRectGetHeight(popupSuperview.frame) - blankViewY;
        CGFloat blankViewX = 0;
        CGFloat blankViewWidth = CGRectGetWidth(popupSuperview.frame);
        CGRect blankViewFrame = CGRectMake(blankViewX,
                                           blankViewY,
                                           blankViewWidth,
                                           blankViewHeight);
        [blankView setFrame:blankViewFrame];
    }
    
    // 2. 计算 popupView 的 frame
    CGRect popupShowFrame = [CJExpandCalculator showFrameFromLeftTop:popupViewOrigin size:popupViewSize];
    
    // 3. 挂载 popupView 进 blankView 容器 / popupSuperview（本次所使用的blankView存储在self.cjTapView）
    BOOL canAdd = [self letPopupSuperview:popupSuperview addPopupView:popupView blankView:blankView];
    if (!canAdd) {  // 挂载失败
        return NO;
    }
    
    self.cjTapBlankViewCompleteBlock = tapBlankViewCompleteBlock;
    
    // 4. 设置 popupView 的最终显示位置（无动画，直接落位）
    popupView.frame = popupShowFrame;
    
    return YES;
}

#pragma mark - 显示（动画）
/** 显示popupView（动画，blankView通过self属性获取，showComplete由外部传入） */
- (void)cj_showAnimateInView:(BOOL)animated
                 showComplete:(void(^)(void))showPopupViewCompleteBlock {
    if (animated == NO) {
        !showPopupViewCompleteBlock ?: showPopupViewCompleteBlock();
        return;
    }
    
    [UIView cj_showExpandAnimateBindView:self
                          withShowFrame:self.frame
                              direction:CJExpandToDirectionDown
                              blankView:self.cjTapView
                             completion:showPopupViewCompleteBlock];
}

/** 完整的描述请参见文件头部 */
- (void)cj_popupHideForView:(BOOL)animated {
    CJPopupMainThreadAssert();
    
    self.cjPopupViewShowing = NO;  //设置成NO表示当前未显示任何弹出视图
    [self endEditing:YES];
    
    UIView *popupView = self;
    UIView *tapView = self.cjTapView;
    
    if (animated == NO) {
        [popupView removeFromSuperview];
        [tapView removeFromSuperview];
        return;
    }
    
    [UIView cj_hideExpandAnimateBindView:self
                              completion:^{
        [popupView removeFromSuperview];
        [tapView removeFromSuperview];
    }];
}


@end
