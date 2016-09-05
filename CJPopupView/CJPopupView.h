//
//  CJPopupView.h
//  CJPopupViewDemo
//
//  Created by lichq on 15/11/12.
//  Copyright (c) 2015年 ciyouzen. All rights reserved.
//


#import "UIView+CJPopupInWindow.h"

#import "UIView+CJPopupInView.h"
#import "UIView+CJShowExtendView.h"


/*
 当前view中的某个point在toView中对应的位置是多少的计算方法
 方法介绍：- (CGPoint)convertPoint:(CGPoint)point toView:(UIView *)view;
 //第一个参数必须为所要转化的rect的视图的父视图，这里可以将父视图直接写出，也可用该视图的superview来替代，这样更方便
 
 */