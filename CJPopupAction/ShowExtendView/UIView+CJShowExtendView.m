//
//  UIView+CJShowExtendView.m
//  CJPopupAction
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJShowExtendView.h"
#import "UIView+CJSlideConvenience.h"
#import <objc/runtime.h>

static NSString *cjExtendViewKey = @"cjExtendView";


@interface UIView ()

@property (nonatomic, strong) UIView *cjExtendView; /**< 当前视图的弹出视图 */

@end

@implementation UIView (CJShowDropView)

#pragma mark - runtime
//cjExtendView
- (UIView *)cjExtendView {
    return objc_getAssociatedObject(self, &cjExtendViewKey);
}

- (void)setCjExtendView:(UIView *)cjExtendView {
    return objc_setAssociatedObject(self, &cjExtendViewKey, cjExtendView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - <#Section#>
/** 完整的描述请参见文件头部 */
- (void)cj_showExtendView:(UIView *)popupView
                   inView:(UIView *)popupSuperview
               atLocation:(CGPoint)popupViewLocation
                 withSize:(CGSize)popupViewSize
                blankView:(nullable UIView *)blankView
             showComplete:(void(^)(void))showPopupViewCompleteBlock
         tapBlankComplete:(void(^)(void))tapBlankViewCompleteBlock
{
    self.cjExtendView = popupView;
    
    /*
    CJPopupRectModel *popupRectModel = [[CJPopupRectModel alloc] init];
    if (blankBGModel != nil) {
        [popupRectModel downPopupWithY:popupViewLocation.y
                                height:popupViewSize.height
                        superViewWidth:CGRectGetWidth(popupSuperview.frame)
                          blankBGColor:blankBGModel.color]; // 占满宽时
    } else {
        [popupRectModel downPopupWithTopLeft:popupViewLocation size:popupViewSize]; // 不占满宽时
    }
    */
    [popupView cj_popupInView:popupSuperview
                     animated:YES
                   withOrigin:popupViewLocation
                         size:popupViewSize
                    blankView:blankView
                 showComplete:showPopupViewCompleteBlock
             tapBlankComplete:tapBlankViewCompleteBlock];
}

/** 完整的描述请参见文件头部 */
- (void)cj_showExtendView:(UIView *)popupView
                   inView:(UIView *)popupSuperview
    locationAccordingView:(UIView *)accordingView
         relativePosition:(CJExpandForViewPosition)popupViewPosition
                blankView:(nullable UIView *)blankView
             showComplete:(void(^)(void))showPopupViewCompleteBlock
         tapBlankComplete:(void(^)(void))tapBlankViewCompleteBlock
{
    NSAssert(accordingView != nil, @"accordingView不能为空,如果为空，请选择 -cj_showExtendView:inView:atLocation:withSize:showComplete:tapBlankComplete:hideComplete:方法");
    
    self.cjExtendView = popupView;
    [popupView cj_expandInView:popupSuperview
                      animated:YES
         locationAccordingView:accordingView
              relativePosition:popupViewPosition
                     blankView:blankView
                  showComplete:showPopupViewCompleteBlock
              tapBlankComplete:tapBlankViewCompleteBlock];
}


/** 完整的描述请参见文件头部 */
- (void)cj_hideExtendViewAnimated:(BOOL)animated {
    [self.cjExtendView cj_popupHideForView:animated];
}

#pragma mark - Slide动画便捷方法
- (void)cq_slideForView:(UIView *)toView
              direction:(CJSlideFromDirection)direction {
    CGRect convertFrame = [self.superview convertRect:toView.frame toView:self.superview];
    CGRect selfFrame = self.frame;
    
    CGFloat spacing = 0;
    switch (direction) {
        case CJSlideFromDirectionTop:
            // 弹出到toView上方：self底部对齐toView顶部
            self.frame = CGRectMake(CGRectGetMinX(convertFrame), CGRectGetMinY(convertFrame) - CGRectGetHeight(selfFrame), CGRectGetWidth(selfFrame), CGRectGetHeight(selfFrame));
            spacing = CGRectGetHeight(selfFrame);
            break;
        case CJSlideFromDirectionBottom:
            // 弹出到toView下方：self顶部对齐toView底部
            self.frame = CGRectMake(CGRectGetMinX(convertFrame), CGRectGetMaxY(convertFrame), CGRectGetWidth(selfFrame), CGRectGetHeight(selfFrame));
            spacing = CGRectGetHeight(selfFrame);
            break;
        case CJSlideFromDirectionLeft:
            // 弹出到toView左侧：self右侧对齐toView左侧
            self.frame = CGRectMake(CGRectGetMinX(convertFrame) - CGRectGetWidth(selfFrame), CGRectGetMinY(convertFrame), CGRectGetWidth(selfFrame), CGRectGetHeight(selfFrame));
            spacing = CGRectGetWidth(selfFrame);
            break;
        case CJSlideFromDirectionRight:
            // 弹出到toView右侧：self左侧对齐toView右侧
            self.frame = CGRectMake(CGRectGetMaxX(convertFrame), CGRectGetMinY(convertFrame), CGRectGetWidth(selfFrame), CGRectGetHeight(selfFrame));
            spacing = CGRectGetWidth(selfFrame);
            break;
    }
    
    [self cq_slideFromOffset:spacing direction:direction];
}

@end
