//
//  UIView+CJShowDropView.h
//  CJPopupViewDemo
//
//  Created by 李超前 on 16/8/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void(^CJTapBlankViewCompleteBlock)(UIView *view);
typedef void(^CJHideExtendViewCompleteBlock)(UIView *view);
typedef void(^CJShowExtendViewCompleteBlock)(void);

@interface UIView (CJShowDropView)

@property (nonatomic, assign, getter=isCJExtendViewShowing) BOOL cjExtendViewShowing;   /**< 判断当前是否有弹出视图显示 */


/**
 *  将本View以size大小弹出到showInView视图中location位置
 *
 *  @param showInView                  弹出视图的父view
 *  @param location                    弹出视图的位置
 *  @param size                        弹出视图的大小
 *  @param showExtendViewCompleteBlock 显示弹出视图后的操作
 *  @param tapBlankViewCompleteBlock   点击空白区域后的操作
 *  @param hideExtendViewCompleteBlock 隐藏弹出视图后的操作
 */
- (void)cj_popupInView:(UIView *)showInView
       atLocationPoint:(CGPoint)location
              withSize:(CGSize)size
          showComplete:(CJShowExtendViewCompleteBlock)showExtendViewCompleteBlock
         tapBGComplete:(CJTapBlankViewCompleteBlock)tapBlankViewCompleteBlock
          hideComplete:(CJHideExtendViewCompleteBlock)hideExtendViewCompleteBlock;

/**
 *  <#Description#>
 *
 *  @param showInView                  弹出视图的父view
 *  @param accordingView               根据accordingView来取得弹出视图的应该的位置和大小
 *  @param showExtendViewCompleteBlock 显示弹出视图后的操作
 *  @param tapBlankViewCompleteBlock   点击空白区域后的操作
 *  @param hideExtendViewCompleteBlock 隐藏弹出视图后的操作
 */
- (void)cj_popupInView:(UIView *)showInView
             underView:(UIView *)accordingView
          showComplete:(CJShowExtendViewCompleteBlock)showExtendViewCompleteBlock
         tapBGComplete:(CJTapBlankViewCompleteBlock)tapBlankViewCompleteBlock
          hideComplete:(CJHideExtendViewCompleteBlock)hideExtendViewCompleteBlock;
/**
 *  显示弹出下拉视图
 *
 *  @param extendView    弹出视图
 *  @param showInVIew    弹出视图被add到的view
 *  @param completeBlock 弹出成功后执行的操作
 */
- (void)cj_showDropDownExtendView:(UIView *)extendView withShowInView:(UIView *)showInVIew completeBlock:(void(^)(void))completeBlock;

/**
 *  隐藏弹出视图
 */
- (void)cj_hideDropDownExtendView;

@end
