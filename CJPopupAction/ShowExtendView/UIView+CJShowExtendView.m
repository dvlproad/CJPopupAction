//
//  UIView+CJShowExtendView.m
//  CJPopupAction
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJShowExtendView.h"

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
             blankBGModel:(nullable CJPopupBlankModel *)blankBGModel
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
                   withOrigin:popupViewLocation
                         size:popupViewSize
                 blankBGModel:blankBGModel
                 showComplete:showPopupViewCompleteBlock
             tapBlankComplete:tapBlankViewCompleteBlock];
}

/** 完整的描述请参见文件头部 */
- (void)cj_showExtendView:(UIView *)popupView
                   inView:(UIView *)popupSuperview
    locationAccordingView:(UIView *)accordingView
         relativePosition:(CJExpandForViewPosition)popupViewPosition
             blankBGModel:(nullable CJPopupBlankModel *)blankBGModel
             showComplete:(void(^)(void))showPopupViewCompleteBlock
         tapBlankComplete:(void(^)(void))tapBlankViewCompleteBlock
{
    NSAssert(accordingView != nil, @"accordingView不能为空,如果为空，请选择 -cj_showExtendView:inView:atLocation:withSize:showComplete:tapBlankComplete:hideComplete:方法");
    
    self.cjExtendView = popupView;
    [popupView cj_expandInView:popupSuperview
         locationAccordingView:accordingView
              relativePosition:popupViewPosition
                 blankBGModel:blankBGModel
                 showComplete:showPopupViewCompleteBlock
             tapBlankComplete:tapBlankViewCompleteBlock];
}


/** 完整的描述请参见文件头部 */
- (void)cj_hideExtendViewAnimated:(BOOL)animated {
    [self.cjExtendView cj_popupHideForView:animated];
}

@end
