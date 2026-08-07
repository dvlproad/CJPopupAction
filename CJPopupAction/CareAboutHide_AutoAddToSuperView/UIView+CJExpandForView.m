//
//  UIView+CJExpandForView.m
//  CJPopupAction
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJExpandForView.h"
#import "UIView+CJPopupInView.h"
#import "UIView+CJExpandRectAnimationBind.h"
#import "CJExpandCalculator.h"

@interface UIView ()

@end


@implementation UIView (CJExpandForView)

#pragma mark - 显示
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
    CJPopupMainThreadAssert();
    
    // 1. 挂载popupView（内部完成blankView创建与挂载、frame设置、tapBlankComplete存储，无动画）
    BOOL canAdd = [self cj_mountInView:popupSuperview
                    locationAccordingView:accordingView
                         relativePosition:popupViewPosition
                                blankView:blankView
                         tapBlankComplete:tapBlankViewCompleteBlock];
    if (!canAdd) {  // 挂载失败
        return;
    }
    
    // 2. 显示（动画）
    [self cj_showAnimateInView:animated
              relativePosition:popupViewPosition
                  showComplete:showPopupViewCompleteBlock];
}

#pragma mark - 挂载popupView（无动画）
/** 完整的描述请参见文件头部 */
- (BOOL)cj_mountInView:(UIView *)popupSuperview
 locationAccordingView:(UIView *)accordingView
      relativePosition:(CJExpandForViewPosition)popupViewPosition
             blankView:(nullable UIView *)blankView
      tapBlankComplete:(void(^)(void))tapBlankViewCompleteBlock
{
    NSAssert(accordingView != nil, @"accordingView不能为空");
    CJPopupMainThreadAssert();
    
    UIView *popupView = self;
    
    CGSize popupViewSize = CGSizeMake(CGRectGetWidth(accordingView.frame), CGRectGetHeight(popupView.frame));
    NSAssert(popupViewSize.height != 0, @"弹出视图的高度不能为0");
    
    // 根据参照视图计算popupView的frame与展开方向
    CGRect accordingFrame = [accordingView.superview convertRect:accordingView.frame toView:popupSuperview];
    CGFloat x = CGRectGetMinX(accordingFrame);
    CGFloat y = CGRectGetMinY(accordingFrame);
    CGFloat w = CGRectGetWidth(accordingFrame);
    CGFloat h = CGRectGetHeight(accordingFrame);
    
    CGRect popupShowFrame;
    switch (popupViewPosition) {
        case CJExpandForViewPositionBelow:
            popupShowFrame = [CJExpandCalculator showFrameFromLeftTop:CGPointMake(x, y + h) size:popupViewSize];
            break;
        case CJExpandForViewPositionAbove:
            popupShowFrame = [CJExpandCalculator showFrameFromLeftBottom:CGPointMake(x, y) size:popupViewSize];
            break;
        case CJExpandForViewPositionCenter:
            popupShowFrame = [CJExpandCalculator showFrameFromCenter:CGPointMake(x + w / 2.0, y + h / 2.0) size:popupViewSize];
            break;
    }
    
    // 1. 挂载 popupView 进 popupSuperview（本次所使用的blankView存储在self.cjTapView）
    BOOL canAdd = [popupView letPopupSuperview:popupSuperview addPopupView:popupView blankView:blankView];
    if (!canAdd) {  // 挂载失败
        return NO;
    }
    
    // 2. 获取本次所使用的blankView并设置其位置为popupSuperview满宽高
    UIView *blankViewResult = popupView.cjTapView;
    if (blankViewResult != nil) {
        blankViewResult.frame = popupSuperview.bounds;
    }
    
    popupView.cjTapBlankViewCompleteBlock = tapBlankViewCompleteBlock;
    
    // 3. 设置 popupView 的最终显示位置（无动画，直接落位）
    popupView.frame = popupShowFrame;
    
    return YES;
}

#pragma mark - 显示（动画）
/** 显示popupView（动画，blankView通过self属性获取，showComplete由外部传入） */
- (void)cj_showAnimateInView:(BOOL)animated
           relativePosition:(CJExpandForViewPosition)popupViewPosition
                showComplete:(void(^)(void))showPopupViewCompleteBlock {
    if (animated == NO) {
        !showPopupViewCompleteBlock ?: showPopupViewCompleteBlock();
        return;
    }
    
    CJExpandToDirection direction;
    switch (popupViewPosition) {
        case CJExpandForViewPositionBelow:
            direction = CJExpandToDirectionDown;
            break;
        case CJExpandForViewPositionAbove:
            direction = CJExpandToDirectionUp;
            break;
        case CJExpandForViewPositionCenter:
            direction = CJExpandToDirectionCenter;
            break;
    }
    
    [UIView cj_showExpandAnimateBindView:self
                          withShowFrame:self.frame
                              direction:direction
                              blankView:self.cjTapView
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
