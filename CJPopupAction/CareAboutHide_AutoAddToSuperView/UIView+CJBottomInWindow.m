//
//  UIView+CJBottomInWindow.m
//  CJPopupAction
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJBottomInWindow.h"
#import "UIView+CJBlankView.h"
#import "UIView+CJPopupInView.h"
#import "UIView+CJSlideTransformAnimationBind.h"
#import "CJExpandCalculator.h"


@interface UIView ()


@end


@implementation UIView (CJBottomInWindow)


#pragma mark - 底层接口
/** 完整的描述请参见文件头部 */
- (void)cj_showInBottomWindow:(BOOL)animated
                   withHeight:(CGFloat)popupViewHeight
                   edgeInsets:(UIEdgeInsets)edgeInsets
                    blankView:(nullable UIView *)blankView
                 showComplete:(void(^)(void))showPopupViewCompleteBlock
             tapBlankComplete:(void(^)(void))tapBlankViewCompleteBlock
{
    CJPopupMainThreadAssert();
    
    // 1. 挂载popupView（内部完成blankView创建与挂载、frame设置、tapBlankComplete存储，无动画）
    BOOL canAdd = [self cj_mountInBottomWindowWithHeight:popupViewHeight
                                                  edgeInsets:edgeInsets
                                                   blankView:blankView
                                            tapBlankComplete:tapBlankViewCompleteBlock];
    if (!canAdd) {  // 挂载失败
        return;
    }
    
    // 2. 显示（动画）
    [self cj_showAnimateInBottomWindow:animated
                           showComplete:showPopupViewCompleteBlock];
}

#pragma mark - 挂载popupView（无动画）
/** 完整的描述请参见文件头部 */
- (BOOL)cj_mountInBottomWindowWithHeight:(CGFloat)popupViewHeight
                                  edgeInsets:(UIEdgeInsets)edgeInsets
                                   blankView:(nullable UIView *)blankView
                            tapBlankComplete:(void(^)(void))tapBlankViewCompleteBlock
{
    CJPopupMainThreadAssert();
    NSAssert(popupViewHeight != 0, @"弹出视图的高都不能为0");
    
    // 弹出在window的中间或底部的不能没有 blankBG 视图，所以强制创建默认遮罩来保证后续能创建出 blankBG 视图
    if (blankView == nil) {
        blankView = [UIView cj_defaultBlankView];
    }
    NSAssert(blankView != nil, @"弹出到window时候，blankView 不能为 nil");
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGFloat popupViewWidth = CGRectGetWidth(keyWindow.frame) - edgeInsets.left - edgeInsets.right;
    CGSize popupViewSize = CGSizeMake(popupViewWidth, popupViewHeight);
    if (CGSizeEqualToSize(self.frame.size, popupViewSize)) {
        NSLog(@"Warning:popupView视图大小将自动调整为指定的弹出视图大小");
        CGRect selfFrame = self.frame;
        selfFrame.size = popupViewSize;
        self.frame = selfFrame;
    }
    
    UIView *popupView = self;
    
    // 1. 挂载 popupView 进 keyWindow（本次所使用的blankView存储在self.cjTapView）
    BOOL canAdd = [self letkeyWindowAddPopupView:popupView blankView:blankView];
    if (!canAdd) {  // 挂载失败
        return NO;
    }
    
    self.cjTapBlankViewCompleteBlock = tapBlankViewCompleteBlock;

    
    // 2. 设置 popupView 的最终显示位置（无动画，直接落位）
    CGFloat popupViewX = edgeInsets.left;
    CGFloat popupViewShowY = CGRectGetHeight(keyWindow.frame) - popupViewHeight - edgeInsets.bottom;
    CGRect popupViewShowFrame = CGRectZero;
    popupViewShowFrame = CGRectMake(popupViewX,
                                    popupViewShowY,
                                    popupViewWidth,
                                    popupViewHeight);
    popupView.frame = popupViewShowFrame;
    
    return YES;
}

#pragma mark - 显示（动画）
/** 显示popupView（动画，blankView通过self属性获取，showComplete由外部传入） */
- (void)cj_showAnimateInBottomWindow:(BOOL)animated
                         showComplete:(void(^)(void))showPopupViewCompleteBlock {
    if (animated == NO) {
        !showPopupViewCompleteBlock ?: showPopupViewCompleteBlock();
        return;
    }
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGFloat slideOffset = CGRectGetHeight(keyWindow.frame) - CGRectGetMinY(self.frame);
    
    // 平移的情况下，初始就得设置好可能存在的 blankView 的显示1.0，及popupView的showFrame
    self.cjTapView.alpha = 1.0;
    self.alpha = 0.2;
    [UIView cj_showSlideAnimateBindView:self
                       withShowDirection:CJSlideFromDirectionBottom
                           animateOffset:slideOffset
                              completion:^(BOOL finished) {
        !showPopupViewCompleteBlock ?: showPopupViewCompleteBlock();
    }];
}

/** 完整的描述请参见文件头部 */
- (void)cj_hideFromBottomWindow:(BOOL)animated {
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
    
    [UIView cj_hideSlideAnimateBindView:self
                             completion:^(BOOL finished) {
        [popupView removeFromSuperview];
        [tapView removeFromSuperview];
    }];
}


@end
