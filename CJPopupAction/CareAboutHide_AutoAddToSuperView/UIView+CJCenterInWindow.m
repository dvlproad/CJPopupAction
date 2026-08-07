//
//  UIView+CJCenterInWindow.m
//  CJPopupAction
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJCenterInWindow.h"
#import <objc/runtime.h>
#import "UIView+CJBlankView.h"
#import "UIView+CJPopupInView.h"
#import "UIView+CJSlideTransformAnimationBind.h"
#import "UIView+CJExpandRectAnimationBind.h"
#import "CJExpandCalculator.h"

@interface UIView ()

@property (nonatomic, assign) CJCenterWindowAnimationType cjPopupCenterAnimationType; /**< 弹出视图到屏幕中间的动画方式 */
@end


@implementation UIView (CJPopupInCenterWindow)

#pragma mark - runtime
//cjPopupCenterAnimationType
- (CJCenterWindowAnimationType)cjPopupCenterAnimationType {
    return [objc_getAssociatedObject(self, @selector(cjPopupCenterAnimationType)) integerValue];
}

- (void)setCjPopupCenterAnimationType:(CJCenterWindowAnimationType)cjPopupCenterAnimationType {
    return objc_setAssociatedObject(self, @selector(cjPopupCenterAnimationType), @(cjPopupCenterAnimationType), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - 底层接口

/* 完整的描述请参见文件头部 */
- (void)cj_showInCenterWindow:(CJCenterWindowAnimationType)animationType
                     withSize:(CGSize)popupViewSize
                    blankView:(nullable UIView *)blankView
                 showComplete:(void(^)(void))showPopupViewCompleteBlock
             tapBlankComplete:(void(^)(void))tapBlankViewCompleteBlock
{
    CJPopupMainThreadAssert();
    
    // 1. 挂载popupView（内部完成blankView创建与挂载、frame设置、tapBlankComplete存储，无动画）
    BOOL canAdd = [self cj_mountInCenterWindowWithSize:popupViewSize
                                                 blankView:blankView
                                          tapBlankComplete:tapBlankViewCompleteBlock];
    if (!canAdd) {  // 挂载失败
        return;
    }
    
    self.cjPopupCenterAnimationType = animationType;
    
    // 2. 显示（动画）
    [self cj_showAnimateInCenterWindow:showPopupViewCompleteBlock];
}

#pragma mark - 挂载popupView（无动画）
/** 完整的描述请参见文件头部 */
- (BOOL)cj_mountInCenterWindowWithSize:(CGSize)popupViewSize
                                 blankView:(nullable UIView *)blankView
                          tapBlankComplete:(void(^)(void))tapBlankViewCompleteBlock
{
    CJPopupMainThreadAssert();
    
    // 弹出在window的中间或底部的不能没有 blankBG 视图，所以强制创建默认遮罩来保证后续能创建出 blankBG 视图
    if (blankView == nil) {
        blankView = [UIView cj_defaultBlankView];
    }
    NSAssert(blankView != nil, @"弹出到window时候，blankView 不能为 nil");
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    UIView *popupView = self;
    UIView *popupSuperview = keyWindow;
    
    NSAssert(popupViewSize.width != 0 && popupViewSize.height != 0, @"弹出视图的宽高都不能为0");
    CGRect frame = popupView.frame;
    frame.size.width = popupViewSize.width;
    frame.size.height = popupViewSize.height;
    popupView.frame = frame;
    
    // 1. 挂载 popupView 进 keyWindow（本次所使用的blankView存储在self.cjTapView）
    BOOL canAdd = [self letkeyWindowAddPopupView:popupView blankView:blankView];
    if (!canAdd) {  // 挂载失败
        return NO;
    }
    
    self.cjTapBlankViewCompleteBlock = tapBlankViewCompleteBlock;
    
    // 2. 设置 popupView 的最终显示位置（无动画，直接落位）
    CGRect popupShowFrame = [CJExpandCalculator showFrameFromCenter:popupSuperview.center size:popupViewSize];
    popupView.frame = popupShowFrame;
    
    return YES;
}

#pragma mark - 显示（动画）
/** 显示popupView（动画，blankView通过self属性获取，showComplete由外部传入） */
- (void)cj_showAnimateInCenterWindow:(void(^)(void))showPopupViewCompleteBlock {
    CJCenterWindowAnimationType animationType = self.cjPopupCenterAnimationType;
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    if (animationType == CJCenterWindowAnimationTypeNone) {
        !showPopupViewCompleteBlock ?: showPopupViewCompleteBlock();
        return;
    }
    
    if (animationType == CJCenterWindowAnimationTypeSlideToCenter
        || animationType == CJCenterWindowAnimationType3DSlideToCenter) {
        // 平移的情况下，初始就得设置好可能存在的 blankView 的显示1.0，及popupView的showFrame
        self.cjTapView.alpha = 1.0;
        
        self.alpha = 0.0;
        if (animationType == CJCenterWindowAnimationTypeSlideToCenter) {
            [UIView cj_showSlideAnimateBindView:self
                               withShowDirection:CJSlideFromDirectionBottom
                                   animateOffset:CGRectGetHeight(keyWindow.frame) / 2.0
                                      completion:^(BOOL finished) {
                !showPopupViewCompleteBlock ?: showPopupViewCompleteBlock();
            }];
        } else {
            [UIView cj_show3DSlideAnimateBindView:self
                               withShowDirection:CJSlideFromDirectionBottom
                                   animateOffset:500
                                     rotateAngle:70.0 * M_PI / 180.0
                                      completion:^(BOOL finished) {
                !showPopupViewCompleteBlock ?: showPopupViewCompleteBlock();
            }];
        }

    } else if (animationType == CJCenterWindowAnimationTypeExpandToCenter) {
        [UIView cj_showExpandAnimateBindView:self
                              withShowFrame:self.frame
                                  direction:CJExpandToDirectionCenter
                                  blankView:self.cjTapView
                                 completion:showPopupViewCompleteBlock];
    }
}


/** 完整的描述请参见文件头部 */
- (void)cj_hideFromCenterWindow:(BOOL)animated {
    CJPopupMainThreadAssert();
    
    CJCenterWindowAnimationType animationType = animated ? self.cjPopupCenterAnimationType : CJCenterWindowAnimationTypeNone;
    self.cjPopupViewShowing = NO;  //设置成NO表示当前未显示任何弹出视图
    [self endEditing:YES];
    
    UIView *popupView = self;
    UIView *tapView = self.cjTapView;
    
    switch (animationType) {
        case CJCenterWindowAnimationTypeNone:
        {
            [popupView removeFromSuperview];
            [tapView removeFromSuperview];
            break;
        }
        case CJCenterWindowAnimationTypeSlideToCenter:
        {
            [UIView cj_slideAnimateView:self
                                forShow:NO
                       withShowDirection:CJSlideFromDirectionBottom
                           animateOffset:CGRectGetHeight(popupView.window.frame) / 2.0
                              completion:^(BOOL finished) {
                [popupView removeFromSuperview];
                [tapView removeFromSuperview];
            }];
            break;
        }
        case CJCenterWindowAnimationType3DSlideToCenter:
        {
            [UIView cj_slide3DAnimateView:self
                                  forShow:NO
                         withShowDirection:CJSlideFromDirectionBottom
                             animateOffset:500
                               rotateAngle:70.0 * M_PI / 180.0
                                completion:^(BOOL finished) {
                [popupView removeFromSuperview];
                [tapView removeFromSuperview];
            }];
            break;
        }
        case CJCenterWindowAnimationTypeExpandToCenter:
        {
            [UIView cj_hideExpandAnimateBindView:self
                                      completion:^{
                [popupView removeFromSuperview];
                [tapView removeFromSuperview];
            }];
            break;
        }
    }
}


@end
