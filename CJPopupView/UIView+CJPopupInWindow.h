//
//  UIView+CJPopupInWindow.h
//  CJPopupViewDemo
//
//  Created by lichq on 6/22/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger, PopupInWindowLocation) {
    PopupInWindowLocationBottom = 0,
    PopupInWindowLocationCenter
};

typedef NS_ENUM(NSUInteger, CJPopupViewAnimation) {
    //    MJPopupViewAnimationFade = 0,
    //    MJPopupViewAnimationSlideBottomTop = 1,
    //    MJPopupViewAnimationSlideBottomBottom,
    //    MJPopupViewAnimationSlideTopTop,
    //    MJPopupViewAnimationSlideTopBottom,
    //    MJPopupViewAnimationSlideLeftLeft,
    //    MJPopupViewAnimationSlideLeftRight,
    //    MJPopupViewAnimationSlideRightLeft,
    //    MJPopupViewAnimationSlideRightRight,
    CJPopupViewAnimationNone = 0,   //Directly
    CJPopupViewAnimationNormal,
    CJPopupViewAnimationCATransform3D
};



@interface UIView (CJPopupInWindow){
    
}
//@property(nonatomic, strong) id customView;
//@property(nonatomic, strong) id<QPopViewDelegate> delegate;
//@property(nonatomic, assign) NSInteger locationType;
//@property(nonatomic, assign) BOOL canDismissAutomatic;//不允许点击其他区域退出，默认允许



- (void)popupInWindowLocationType:(PopupInWindowLocation)locationType animationType:(CJPopupViewAnimation)animationType;
- (void)dismissPopupViewInWindowWithAnimationType:(CJPopupViewAnimation)animationType;

@end
