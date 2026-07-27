//
//  UIView+CJExpandForView.m
//  CJPopupAction
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJExpandForView.h"
#import "UIView+CJPopupInView.h"
#import "UIView+CJExpandFrameAnimationBind.h"
#import "CJExpandCalculator.h"

@interface UIView ()

@end


@implementation UIView (CJExpandForView)

#pragma mark - 底层接口
#pragma mark - ExtendView
/** 完整的描述请参见文件头部 */
- (void)cj_expandInView:(UIView *)popupSuperview
               animated:(BOOL)animated
  locationAccordingView:(UIView *)accordingView
       relativePosition:(CJExpandForViewPosition)popupViewPosition
              blankView:(nullable UIView *)blankView
           showComplete:(void(^)(void))showPopupViewCompleteBlock
       tapBlankComplete:(void(^)(void))tapBlankViewCompleteBlock
{
    NSAssert(accordingView != nil, @"accordingView不能为空");
    
    UIView *popupView = self;
    
    CGSize popupViewSize = CGSizeMake(CGRectGetWidth(accordingView.frame), CGRectGetHeight(popupView.frame));
    NSAssert(popupViewSize.height != 0, @"弹出视图的高度不能为0");
    
    CGRect accordingFrame = [accordingView.superview convertRect:accordingView.frame toView:popupSuperview];
    CGFloat x = CGRectGetMinX(accordingFrame);
    CGFloat y = CGRectGetMinY(accordingFrame);
    CGFloat w = CGRectGetWidth(accordingFrame);
    CGFloat h = CGRectGetHeight(accordingFrame);
    
    CJExpandFramePair pair;
    switch (popupViewPosition) {
        case CJExpandForViewPositionBelow:
            pair = [CJExpandCalculator expandToDownFromLeftTop:CGPointMake(x, y + h) size:popupViewSize];
            break;
        case CJExpandForViewPositionAbove:
            pair = [CJExpandCalculator expandToUpFromLeftBottom:CGPointMake(x, y) size:popupViewSize];
            break;
        case CJExpandForViewPositionCenter:
            pair = [CJExpandCalculator expandToCenterFromCenter:CGPointMake(x + w / 2.0, y + h / 2.0) size:popupViewSize];
            break;
    }
    
    CJPopupMainThreadAssert();
    
    BOOL canAdd = [popupView letPopupSuperview:popupSuperview addPopupView:popupView blankView:blankView];
    if (!canAdd) {
        return;
    }
    
    if (popupView.cjTapView != nil) {
        popupView.cjTapView.frame = popupSuperview.bounds;
    }
    
    popupView.cjShowPopupViewCompleteBlock = showPopupViewCompleteBlock;
    popupView.cjTapBlankViewCompleteBlock = tapBlankViewCompleteBlock;
    
    if (animated == NO) {
        popupView.frame = pair.showFrame;
        !showPopupViewCompleteBlock ?: showPopupViewCompleteBlock();
        return;
    }
    
    [UIView cj_showExpandAnimateBindView:popupView
                          withShowFrame:pair.showFrame
                              hideFrame:pair.hideFrame
                              blankView:popupView.cjTapView
                             completion:showPopupViewCompleteBlock];
}



/** 完整的描述请参见文件头部 */
- (void)cj_expandHideForView:(BOOL)animated {
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
