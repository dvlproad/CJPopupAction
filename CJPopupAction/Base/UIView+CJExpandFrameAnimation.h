//
//  UIView+CJExpandFrameAnimation.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//
//  展开动画：不一定需要blankView

#import <UIKit/UIKit.h>

static CGFloat kCJPopupAnimationDuration = 0.3;

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CJExpandFrameAnimation) {
    
}

+ (void)cj_expandAnimateView:(UIView *)animatedView
                      forShow:(BOOL)forShow
                withShowFrame:(CGRect)popupViewShowFrame
                    hideFrame:(CGRect)popupViewHideFrame
                    blankView:(nullable UIView *)blankView
                   completion:(void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
