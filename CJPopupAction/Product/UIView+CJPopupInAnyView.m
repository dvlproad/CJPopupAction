//
//  UIView+CJPopupInAnyView.m
//  CJPopupAction
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJPopupInAnyView.h"
#import "UIView+CJPopupInView.h"
#import "UIView+CJSlideAnimation.h"
#import "CJExpandCalculator.h"

static NSString *cjPopupAnimationTypeKey = @"cjPopupAnimationType";

static NSString *cjPopupViewHideTransformKey = @"cjPopupViewHideTransform";

@interface UIView ()

@property (nonatomic, assign) CJAnimationType cjPopupAnimationType; /**< 弹出视图的动画方式 */

//@property (nonatomic, assign) CATransform3D cjPopupViewHideTransform;/**< 弹出视图隐藏时候的transform */

@end


@implementation UIView (CJPopupInAnyView)

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
          blankBGModel:(nullable CJPopupBlankModel *)blankBGModel
//        popupRectModel:(CJPopupRectModel *)popupRectModel
          showComplete:(void(^)(void))showPopupViewCompleteBlock
      tapBlankComplete:(void(^)(void))tapBlankViewCompleteBlock
{
    CJPopupMainThreadAssert();
    
    UIView *popupView = self;
    
    BOOL canAdd = [self letPopupSuperview:popupSuperview addPopupView:popupView withBlankBGModel:blankBGModel];
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
    
    CJPopupFramePair pair = [CJExpandCalculator expandToDownFromLeftTop:popupViewOrigin size:popupViewSize];
    self.cjPopupViewHideFrameString = NSStringFromCGRect(pair.hideFrame);
    [self cj_showExpandViewWithShowFrame:pair.showFrame hideFrame:pair.hideFrame showComplete:showPopupViewCompleteBlock];
}

/** 完整的描述请参见文件头部 */
- (void)cj_hidePopupView {
    CJAnimationType animationType = self.cjPopupAnimationType;
    [self cj_hidePopupViewWithAnimationType:animationType];
}

#pragma mark - 底层内部方法
- (void)cj_windowSlideViewForShow:(BOOL)forShow
                withShowDirection:(CJSlideFromDirection)direction
                           offset:(CGFloat)offset
                       completion:(void (^ __nullable)(BOOL finished))completion
{
    UIView *popupView = self;
    UIView *blankView = self.cjTapView;
    /*
    CGAffineTransform hideTransform = [CJExpandCalculator slideHideTransformWithDirection:direction offset:offset];
    
    popupView.frame = popupViewShowFrame;
    popupView.transform = hideTransform;
    blankView.alpha = 0.2;
    popupView.alpha = 0.2;
    [UIView animateWithDuration:kCJPopupAnimationDuration
                     animations:^{
                         blankView.alpha = 1.0;
                         popupView.alpha = 1.0;
                         popupView.transform = CGAffineTransformIdentity;
                     }];
    */
    blankView.alpha = forShow ? 0.2 : 1.0;
    [popupView cj_slideAnimateForShow:forShow withShowDirection:direction animateOffset:offset completion:^(BOOL finished) {
        blankView.alpha = forShow ? 1.0 : 0.0;
        !completion ?: completion(finished);
    }];
}

/** 完整的描述请参见文件头部 */
- (void)cj_hidePopupViewWithAnimationType:(CJAnimationType)animationType {
    CJPopupMainThreadAssert();
    
    self.cjPopupViewShowing = NO;  //设置成NO表示当前未显示任何弹出视图
    [self endEditing:YES];
    
    UIView *popupView = self;
    UIView *tapView = self.cjTapView;
    
    switch (animationType) {
        case CJAnimationTypeNone:
        {
            [popupView removeFromSuperview];
            [tapView removeFromSuperview];
            break;
        }
        case CJAnimationTypeNormal:
        {
            CGRect popupViewHideFrame = CGRectFromString(self.cjPopupViewHideFrameString);
            if (CGRectEqualToRect(popupViewHideFrame, CGRectZero)) {
                popupViewHideFrame = self.frame;
            }
            
            [UIView animateWithDuration:kCJPopupAnimationDuration
                             animations:^{
                                 //要设置成0，不设置非零值如0.2，是为了防止在显示出来的时候，在0.3秒内很快按两次按钮，仍有view存在
                                 tapView.alpha = 0.0f;
                                 popupView.alpha = 0.0f;
                                 popupView.frame = popupViewHideFrame;
                                 
                             }completion:^(BOOL finished) {
                                 [popupView removeFromSuperview];
                                 [tapView removeFromSuperview];
                             }];
            break;
        }
        case CJAnimationTypeCATransform3D:
        {
            [UIView animateWithDuration:kCJPopupAnimationDuration
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 CATransform3D rotate = CATransform3DMakeRotation(-70.0 * M_PI / 180.0, 0.0, 0.0, 1.0);
                                 CATransform3D translate = CATransform3DMakeTranslation(-20.0, 500.0, 0.0);
                                 popupView.layer.transform = CATransform3DConcat(rotate, translate);
                                 
                             } completion:^(BOOL finished) {
                                 [popupView removeFromSuperview];
                                 [tapView removeFromSuperview];
                             }];
            break;
        }
    }
}

#pragma mark - ExtendView
/** 完整的描述请参见文件头部 */
- (void)cj_expandInView:(UIView *)popupSuperview
  locationAccordingView:(UIView *)accordingView
       relativePosition:(CJPopupViewPosition)popupViewPosition
           blankBGModel:(nullable CJPopupBlankModel *)blankBGModel
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
    
    CJPopupFramePair pair;
    switch (popupViewPosition) {
        case CJPopupViewPositionBelow:
            pair = [CJExpandCalculator expandToDownFromLeftTop:CGPointMake(x, y + h) size:popupViewSize];
            break;
        case CJPopupViewPositionAbove:
            pair = [CJExpandCalculator expandToUpFromLeftBottom:CGPointMake(x, y) size:popupViewSize];
            break;
        case CJPopupViewPositionCenter:
            pair = [CJExpandCalculator expandToCenterFromCenter:CGPointMake(x + w / 2.0, y + h / 2.0) size:popupViewSize];
            break;
    }
    
    CJPopupMainThreadAssert();
    
    BOOL canAdd = [popupView letPopupSuperview:popupSuperview addPopupView:popupView withBlankBGModel:blankBGModel];
    if (!canAdd) {
        return;
    }
    
    popupView.cjShowPopupViewCompleteBlock = showPopupViewCompleteBlock;
    popupView.cjTapBlankViewCompleteBlock = tapBlankViewCompleteBlock;
    
    popupView.cjPopupViewHideFrameString = NSStringFromCGRect(pair.hideFrame);
    [popupView cj_showExpandViewWithShowFrame:pair.showFrame hideFrame:pair.hideFrame showComplete:showPopupViewCompleteBlock];
}


@end
