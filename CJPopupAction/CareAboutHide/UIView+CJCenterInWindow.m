//
//  UIView+CJCenterInWindow.m
//  CJPopupAction
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJCenterInWindow.h"
#import "UIView+CJPopupInView.h"
#import "UIView+CJSlideAnimation.h"
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
                 blankBGColor:(nullable UIColor *)blankBGColor
                 showComplete:(void(^)(void))showPopupViewCompleteBlock
             tapBlankComplete:(void(^)(void))tapBlankViewCompleteBlock
{
    CJPopupMainThreadAssert();
    
    // 弹出在window的中间或底部的不能没有 blankBG 视图，所以强制创建 blankBGModel 来让保证后续能创建出 blankBG 视图
    CJPopupBlankModel *blankBGModel = blankBGColor != nil ? [CJPopupBlankModel modelWidthColor:blankBGColor] : [CJPopupBlankModel defaultModel];
    NSAssert(blankBGModel != nil, @"弹出到window时候，blankBGModel 不能为 nil");
    
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    UIView *popupView = self;
    UIView *popupSuperview = keyWindow;
    
    NSAssert(popupViewSize.width != 0 && popupViewSize.height != 0, @"弹出视图的宽高都不能为0");
    CGRect frame = popupView.frame;
    frame.size.width = popupViewSize.width;
    frame.size.height = popupViewSize.height;
    popupView.frame = frame;
    
    BOOL canAdd = [self letkeyWindowAddPopupView:popupView withBlankBGModel:blankBGModel];
    if (!canAdd) {
        return;
    }
    
    
    self.cjPopupCenterAnimationType = animationType;
    self.cjShowPopupViewCompleteBlock = showPopupViewCompleteBlock;
    self.cjTapBlankViewCompleteBlock = tapBlankViewCompleteBlock;

    CJExpandFramePair pair = [CJExpandCalculator expandToCenterFromCenter:popupSuperview.center size:popupViewSize];
    self.cjPopupViewHideFrameString = NSStringFromCGRect(pair.hideFrame);

    if (animationType == CJCenterWindowAnimationTypeNone) {
        popupView.frame = pair.showFrame;
        !showPopupViewCompleteBlock ?: showPopupViewCompleteBlock();

    } else if (animationType == CJCenterWindowAnimationTypeSlideToCenter
               || animationType == CJCenterWindowAnimationType3DSlideToCenter) {
        // 平移的情况下，初始就得设置好可能存在的 blankView 的显示1.0，及popupView的showFrame
        UIView *blankView = self.cjTapView;
        blankView.alpha = 1.0;
        
        popupView.frame = pair.showFrame;
        
        popupView.alpha = 0.0;
        if (animationType == CJCenterWindowAnimationTypeSlideToCenter) {
            [self cj_slideAnimateForShow:YES
                       withShowDirection:CJSlideFromDirectionBottom
                           animateOffset:CGRectGetHeight(keyWindow.frame) / 2.0
                              completion:^(BOOL finished) {
                !showPopupViewCompleteBlock ?: showPopupViewCompleteBlock();
            }];
        } else {
            [self cj_3DSlideAnimateForShow:YES
                         withShowDirection:CJSlideFromDirectionBottom
                             animateOffset:500
                               rotateAngle:70.0 * M_PI / 180.0
                                completion:^(BOOL finished) {
                !showPopupViewCompleteBlock ?: showPopupViewCompleteBlock();
            }];
        }

    } else if (animationType == CJCenterWindowAnimationTypeExpandToCenter) {
        [self cj_expandAnimateForShow:YES
                        withShowFrame:pair.showFrame
                            hideFrame:pair.hideFrame
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
            [self cj_slideAnimateForShow:NO
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
            [self cj_3DSlideAnimateForShow:NO
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
            CGRect popupViewHideFrame = CGRectFromString(self.cjPopupViewHideFrameString);
            if (CGRectEqualToRect(popupViewHideFrame, CGRectZero)) {
                popupViewHideFrame = self.frame;
            }
            
            [self cj_expandAnimateForShow:NO
                            withShowFrame:self.frame
                                hideFrame:popupViewHideFrame
                                blankView:tapView
                               completion:^{
                [popupView removeFromSuperview];
                [tapView removeFromSuperview];
            }];
            break;
        }
    }
}


@end
