//
//  UIView+CJExpandByPoint.m
//  CJPopupAction
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJExpandByPoint.h"
#import "UIView+CJPopupInView.h"
#import "UIView+CJExpandFrameAnimation.h"
#import "UIView+CJSlideTransformAnimation.h"
#import "CJExpandCalculator.h"

static NSString *cjPopupAnimationTypeKey = @"cjPopupAnimationType";

static NSString *cjPopupViewHideTransformKey = @"cjPopupViewHideTransform";

@interface UIView ()

@property (nonatomic, assign) CJAnimationType cjPopupAnimationType; /**< 弹出视图的动画方式 */

//@property (nonatomic, assign) CATransform3D cjPopupViewHideTransform;/**< 弹出视图隐藏时候的transform */

@end


@implementation UIView (CJExpandByPoint)

#pragma mark - runtime
//cjPopupAnimationType
- (CJAnimationType)cjPopupAnimationType {
    return [objc_getAssociatedObject(self, &cjPopupAnimationTypeKey) integerValue];
}

- (void)setCjPopupAnimationType:(CJAnimationType)cjPopupAnimationType {
    return objc_setAssociatedObject(self, &cjPopupAnimationTypeKey, @(cjPopupAnimationType), OBJC_ASSOCIATION_ASSIGN);
}

////cjPopupViewHideTransform
//- (CATransform3D)cjPopupViewHideTransform {
//    return objc_getAssociatedObject(self, &cjPopupViewHideTransformKey);
//}
//
//- (void)setCjPopupViewHideTransform:(CATransform3D)cjPopupViewHideTransform {
//    return objc_setAssociatedObject(self, &cjPopupViewHideTransformKey, cjPopupViewHideTransform, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

#pragma mark - 底层接口
/** 完整的描述请参见文件头部 */
- (void)cj_popupInView:(UIView *)popupSuperview
            withOrigin:(CGPoint)popupViewOrigin
                  size:(CGSize)popupViewSize
//        popupRectModel:(CJPopupRectModel *)popupRectModel
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
    

    self.cjPopupAnimationType = CJAnimationTypeNormal;
    self.cjShowPopupViewCompleteBlock = showPopupViewCompleteBlock;
    self.cjTapBlankViewCompleteBlock = tapBlankViewCompleteBlock;
    
    CJExpandFramePair pair = [CJExpandCalculator expandToDownFromLeftTop:popupViewOrigin size:popupViewSize];
    self.cjPopupViewHideFrameString = NSStringFromCGRect(pair.hideFrame);
    [UIView cj_expandAnimateView:self
                          forShow:YES
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
    
    CGRect popupViewHideFrame = CGRectFromString(self.cjPopupViewHideFrameString);
    if (CGRectEqualToRect(popupViewHideFrame, CGRectZero)) {
        popupViewHideFrame = self.frame;
    }
    
    [UIView cj_expandAnimateView:popupView
                          forShow:NO
                    withShowFrame:popupView.frame
                        hideFrame:popupViewHideFrame
                        blankView:tapView
                       completion:^{
        [popupView removeFromSuperview];
        [tapView removeFromSuperview];
    }];
}


@end
