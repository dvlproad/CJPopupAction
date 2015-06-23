//
//  UIView+CJPopupView.h
//  CJPopupViewDemo
//
//  Created by lichq on 6/22/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    CJPopupViewLocationBottom = 0,
    CJPopupViewLocationCenter
}CJPopupViewLocation;

typedef enum {
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
    
} CJPopupViewAnimation;



@interface UIView (CJPopupView){
    
}
//@property(nonatomic, strong) id customView;
//@property(nonatomic, strong) id<QPopViewDelegate> delegate;
//@property(nonatomic, assign) NSInteger locationType;
//@property(nonatomic, assign) BOOL canDismissAutomatic;//不允许点击其他区域退出，默认允许



- (void)showInLocationType:(CJPopupViewLocation)locationType animationType:(CJPopupViewAnimation)animationType;
- (void)dismissPopupViewWithAnimationType:(CJPopupViewAnimation)animationType;

@end
