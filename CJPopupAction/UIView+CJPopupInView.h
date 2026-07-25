//
//  UIView+CJPopupInView.h
//  CJPopupAction
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "CJPopupCalculator.h"
#import "CJPopupBlankModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CJTapBlankViewCompleteBlock)(void);


typedef NS_ENUM(NSUInteger, CJWindowPosition) {
    CJWindowPositionBottom = 0,
    CJWindowPositionCenter
};

typedef NS_ENUM(NSUInteger, CJAnimationType) {
    //    MJPopupViewAnimationFade = 0,
    //    MJPopupViewAnimationSlideBottomTop = 1,
    //    MJPopupViewAnimationSlideBottomBottom,
    //    MJPopupViewAnimationSlideTopTop,
    //    MJPopupViewAnimationSlideTopBottom,
    //    MJPopupViewAnimationSlideLeftLeft,
    //    MJPopupViewAnimationSlideLeftRight,
    //    MJPopupViewAnimationSlideRightLeft,
    //    MJPopupViewAnimationSlideRightRight,
    CJAnimationTypeNone = 0,   //Directly
    CJAnimationTypeNormal,     //通过设置frame来实现
    CJAnimationTypeCATransform3D
};

@interface UIView (CJPopupInView) {
    
}
@property (nonatomic, assign, readonly, getter=isCJPopupViewShowing) BOOL cjPopupViewShowing;   /**< 判断当前是否有弹出视图显示 */

/**
 *  将本View以size大小弹出到showInView视图中location位置（固定向下展开）
 *
 *  @param popupSuperview               弹出视图的父视图view
 *  @param popupViewOrigin              弹出视图的左上角origin坐标
 *  @param popupViewSize                弹出视图的size大小
 *  @param blankBGModel                 空白遮罩模型（不传则不添加遮罩）
 *  @param showPopupViewCompleteBlock   显示弹出视图后的操作
 *  @param tapBlankViewCompleteBlock    点击空白区域后的操作(要自己执行cj_hidePopupView...来隐藏，因为有时候点击背景是不执行隐藏的)
 */
- (void)cj_popupInView:(UIView *)popupSuperview
            withOrigin:(CGPoint)popupViewOrigin
                  size:(CGSize)popupViewSize
           blankBGModel:(nullable CJPopupBlankModel *)blankBGModel
          showComplete:(void(^)(void))showPopupViewCompleteBlock
      tapBlankComplete:(void(^)(void))tapBlankViewCompleteBlock;


/**
 *  将当前视图弹出到window中央
 *
 *  @param animationType                弹出时候的动画采用的类型
 *  @param popupViewSize                弹出视图的大小
 *  @param blankBGColor                 空白区域的自定义背景颜色
 *  @param showPopupViewCompleteBlock   显示弹出视图后的操作
 *  @param tapBlankViewCompleteBlock    点击空白区域后的操作(要自己执行cj_hidePopupView...来隐藏，因为有时候点击背景是不执行隐藏的)
 */
- (void)cj_popupInCenterWindow:(CJAnimationType)animationType
                      withSize:(CGSize)popupViewSize
                  blankBGColor:(nullable UIColor *)blankBGColor
                  showComplete:(void(^)(void))showPopupViewCompleteBlock
              tapBlankComplete:(void(^)(void))tapBlankViewCompleteBlock;


/**
 *  将当前视图弹出到window底部
 *
 *  @param animationType                弹出时候的动画采用的类型
 *  @param popupViewHeight              弹出视图的高度
 *  @param edgeInsets                   弹窗与window的(左右下)边距
 *  @param blankBGColor                 空白区域的自定义背景颜色
 *  @param showPopupViewCompleteBlock   显示弹出视图后的操作
 *  @param tapBlankViewCompleteBlock    点击空白区域后的操作(要自己执行cj_hidePopupView...来隐藏，因为有时候点击背景是不执行隐藏的)
 */
- (void)cj_popupInBottomWindow:(CJAnimationType)animationType
                    withHeight:(CGFloat)popupViewHeight
                    edgeInsets:(UIEdgeInsets)edgeInsets
                  blankBGColor:(nullable UIColor *)blankBGColor
                  showComplete:(void(^)(void))showPopupViewCompleteBlock
              tapBlankComplete:(void(^)(void))tapBlankViewCompleteBlock;






#pragma mark - ExtendView（基于cj_popupInView的封装）

/// 弹窗相对于参照视图的位置（左右请直接调用 expandToLeft/Right 方法）
typedef NS_ENUM(NSUInteger, CJPopupViewPosition) {
    CJPopupViewPositionBelow = 0,   // 在参照视图下方（向下展开）
    CJPopupViewPositionAbove,       // 在参照视图上方（向上展开）
    CJPopupViewPositionCenter,      // 居中于参照视图（向四周展开）
};
/**
 *  在popupSuperview中展开自己，位置根据与参照视图accordingView的关系确定
 *  要隐藏时，对弹出视图调用 cj_hidePopupView
 */
- (void)cj_expandInView:(UIView *)popupSuperview
  locationAccordingView:(UIView *)accordingView
       relativePosition:(CJPopupViewPosition)popupViewPosition
           blankBGModel:(nullable CJPopupBlankModel *)blankBGModel
           showComplete:(void(^)(void))showPopupViewCompleteBlock
       tapBlankComplete:(void(^)(void))tapBlankViewCompleteBlock;





#pragma mark - 隐藏

/**
 *  隐藏弹出视图
 */
- (void)cj_hidePopupView;
/**
 *  隐藏弹出视图
 */
- (void)cj_hidePopupViewWithAnimationType:(CJAnimationType)animationType;

@end


NS_ASSUME_NONNULL_END
