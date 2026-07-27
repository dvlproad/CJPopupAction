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

#pragma mark - 底层接口
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
    
    UIView *popupView = self;
    
    BOOL canAdd = [self letPopupSuperview:popupSuperview addPopupView:popupView blankView:blankView];
    if (!canAdd) {
        return;
    }
    
    if (self.cjTapView != nil) { // 如果之前没创建 blankBG 视图，则不需要设置其frame。
        // 此处有设置，则blankBG的宽为popupSuperview满宽(下拉菜单，不必支持非popupSuperview满宽的情况，视觉体验不好)
        UIView *blankView = self.cjTapView;
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
    
    self.cjShowPopupViewCompleteBlock = showPopupViewCompleteBlock;
    self.cjTapBlankViewCompleteBlock = tapBlankViewCompleteBlock;
    
    CJExpandFramePair pair = [CJExpandCalculator expandToDownFromLeftTop:popupViewOrigin size:popupViewSize];
    
    if (animated == NO) {
        popupView.frame = pair.showFrame;
        !showPopupViewCompleteBlock ?: showPopupViewCompleteBlock();
        return;
    }
    
    [UIView cj_showExpandAnimateBindView:self
                          withShowFrame:pair.showFrame
                              hideFrame:pair.hideFrame
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
