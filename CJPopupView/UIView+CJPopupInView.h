//
//  UIView+CJPopupInView.h
//  CJPopupViewDemo
//
//  Created by lichq on 15/11/12.
//  Copyright (c) 2015年 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void(^CJTapBlankViewCompleteBlock)(void);
typedef void(^CJHidePopupViewCompleteBlock)(void);
typedef void(^CJShowPopupViewCompleteBlock)(void);

@interface UIView (CJPopupInView) {
    
}
@property (nonatomic, assign, getter=isCJPopupViewShowing) BOOL cjPopupViewShowing;   /**< 判断当前是否有弹出视图显示 */

/**
 *  将本View以size大小弹出到showInView视图中location位置
 *
 *  @param showInView                  弹出视图的父view
 *  @param location                    弹出视图的位置
 *  @param size                        弹出视图的大小
 *  @param showPopupViewCompleteBlock  显示弹出视图后的操作
 *  @param tapBlankViewCompleteBlock   点击空白区域后的操作
 *  @param hidePopupViewCompleteBlock  隐藏弹出视图后的操作
 */
- (void)cj_popupInView:(UIView *)showInView
       atLocationPoint:(CGPoint)location
              withSize:(CGSize)size
          showComplete:(CJShowPopupViewCompleteBlock)showPopupViewCompleteBlock
      tapBlankComplete:(CJTapBlankViewCompleteBlock)tapBlankViewCompleteBlock
          hideComplete:(CJHidePopupViewCompleteBlock)hidePopupViewCompleteBlock;

/**
 *  隐藏弹出视图
 */
- (void)cj_hidePopupViewAnimated:(BOOL)animated;

@end
