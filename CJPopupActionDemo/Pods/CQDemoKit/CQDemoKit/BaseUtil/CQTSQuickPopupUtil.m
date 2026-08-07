//
//  CQTSQuickPopupUtil.m
//  CQDemoKit
//
//  Created by ciyouzen on 2026/08/04.
//

#import "CQTSQuickPopupUtil.h"

#import "CQTSBottomBlankView.h"
#import "CQTSCenterBlankView.h"

@implementation CQTSQuickPopupUtil

+ (nullable CQTSBottomBlankView *)showWindowBottomClearView:(UIView *)contentView
                                                     height:(CGFloat)popupViewHeight
                                           tapBlankComplete:(void(^ _Nullable)(CQTSBottomBlankView *bBlankView))tapBlankComplete
{
    if (contentView == nil) {
        return nil;
    }
    CQTSBottomBlankView *blankView = [[CQTSBottomBlankView alloc] initWithPopupView:contentView
                                                                    popupViewHeight:popupViewHeight
                                                                   tapBlankComplete:tapBlankComplete];
    [blankView showBlankViewInView:nil complete:nil];
    return blankView;
}

#pragma mark - Center
+ (nullable CQTSCenterBlankView *)showWindowCenterClearView:(UIView *)contentView
                                                       size:(CGSize)popupViewSize
                                           tapBlankComplete:(void(^ _Nullable)(CQTSCenterBlankView *bBlankView))tapBlankComplete
{
    if (contentView == nil) {
        return nil;
    }
    CQTSCenterBlankView *blankView = [[CQTSCenterBlankView alloc] initWithPopupView:contentView
                                                                      popupViewSize:popupViewSize
                                                                  popupCenterOffset:CGPointZero
                                                                   tapBlankComplete:tapBlankComplete];
    [blankView showBlankViewInView:nil complete:nil];
    return blankView;
}

@end
