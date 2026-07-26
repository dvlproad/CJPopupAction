//
//  UIView+CJBottomInWindow.m
//  CJPopupAction
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJBottomInWindow.h"
#import "UIView+CJPopupInView.h"
#import "UIView+CJSlideAnimation.h"
#import "CJExpandCalculator.h"


@interface UIView ()


@end


@implementation UIView (CJExpandByPoint)


#pragma mark - 底层接口
/** 完整的描述请参见文件头部 */
- (void)cj_showInBottomWindow:(BOOL)animated
                   withHeight:(CGFloat)popupViewHeight
                   edgeInsets:(UIEdgeInsets)edgeInsets
                 blankBGColor:(nullable UIColor *)blankBGColor
                 showComplete:(void(^)(void))showPopupViewCompleteBlock
             tapBlankComplete:(void(^)(void))tapBlankViewCompleteBlock
{
    CJPopupMainThreadAssert();
    NSAssert(popupViewHeight != 0, @"弹出视图的高都不能为0");
    
    // 弹出在window的中间或底部的不能没有 blankBG 视图，所以强制创建 blankBGModel 来让保证后续能创建出 blankBG 视图
    CJPopupBlankModel *blankBGModel = blankBGColor != nil ? [CJPopupBlankModel modelWidthColor:blankBGColor] : [CJPopupBlankModel defaultModel];
    NSAssert(blankBGModel != nil, @"弹出到window时候，blankBGModel 不能为 nil");
    
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
    
    BOOL canAdd = [self letkeyWindowAddPopupView:popupView withBlankBGModel:blankBGModel];
    if (!canAdd) {
        return;
    }
    
    self.cjShowPopupViewCompleteBlock = showPopupViewCompleteBlock;
    self.cjTapBlankViewCompleteBlock = tapBlankViewCompleteBlock;

    
    //popupViewShowFrame
    CGFloat popupViewX = edgeInsets.left;
    CGFloat popupViewShowY = CGRectGetHeight(keyWindow.frame) - popupViewHeight - edgeInsets.bottom;
    CGRect popupViewShowFrame = CGRectZero;
    popupViewShowFrame = CGRectMake(popupViewX,
                                    popupViewShowY,
                                    popupViewWidth,
                                    popupViewHeight);
    
    if (animated == NO) {
        popupView.frame = popupViewShowFrame;
        !showPopupViewCompleteBlock ?: showPopupViewCompleteBlock();
        
    } else {
        CGFloat slideOffset = CGRectGetHeight(keyWindow.frame) - popupViewShowY;
        self.cjPopupViewHideFrameString = NSStringFromCGRect(CGRectMake(popupViewX,
                                                                        CGRectGetMaxY(keyWindow.frame),
                                                                        popupViewWidth,
                                                                        popupViewHeight));

        
        // 平移的情况下，初始就得设置好可能存在的 blankView 的显示1.0，及popupView的showFrame
        UIView *blankView = self.cjTapView;
        blankView.alpha = 1.0;
        
        popupView.frame = popupViewShowFrame;
        
        popupView.alpha = 0.2;
        [self cj_slideAnimateForShow:YES
                   withShowDirection:CJSlideFromDirectionBottom
                       animateOffset:slideOffset
                          completion:^(BOOL finished) {
            !showPopupViewCompleteBlock ?: showPopupViewCompleteBlock();
        }];
    }
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
    
    CGFloat slideOffset = CGRectGetHeight(popupView.window.frame) - self.frame.origin.y;
    [self cj_slideAnimateForShow:NO
               withShowDirection:CJSlideFromDirectionBottom
                   animateOffset:slideOffset
                      completion:^(BOOL finished) {
        [popupView removeFromSuperview];
        [tapView removeFromSuperview];
    }];
}


@end
