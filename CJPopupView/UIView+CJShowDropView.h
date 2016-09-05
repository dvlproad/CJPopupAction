//
//  UIView+CJShowDropView.h
//  CJPopupViewDemo
//
//  Created by lichq on 15/11/12.
//  Copyright (c) 2015年 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CJPopupInView.h"


typedef NS_ENUM(NSUInteger, CJPopupViewPosition) {
    CJPopupViewPositionUnder
};

@interface UIView (CJShowDropView)


#pragma mark - 外部接口
/**
 *  显示当前视图的下拉视图
 *
 *  @param popupView    弹出视图
 *  @param showInVIew    弹出视图被add到的view
 *  @param showPopupViewCompleteBlock  显示弹出视图后的操作
 *  @param tapBlankViewCompleteBlock   点击空白区域后的操作
 *  @param hidePopupViewCompleteBlock  隐藏弹出视图后的操作
 */
- (void)cj_showDropDownView:(UIView *)popupView
             withShowInView:(UIView *)showInView
               showComplete:(CJShowPopupViewCompleteBlock)showPopupViewCompleteBlock
           tapBlankComplete:(CJTapBlankViewCompleteBlock)tapBlankViewCompleteBlock
               hideComplete:(CJHidePopupViewCompleteBlock)hidePopupViewCompleteBlock;

/**
 *  隐藏下拉视图
 *
 *  @param animated 是否动画
 */
- (void)cj_hideDropDownViewAnimated:(BOOL)animated;

@end
