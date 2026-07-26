//
//  UIView+CJBlankView.m
//  CJPopupAction
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJBlankView.h"

@implementation UIView (CJBlankView)

+ (UIView *)cj_defaultBlankView {
    UIView *blankView = [[UIView alloc] init];
    blankView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.6];
    return blankView;
}

+ (UIView *)cj_blankViewWithColor:(UIColor *)color {
    UIView *blankView = [[UIView alloc] init];
    blankView.backgroundColor = color;
    return blankView;
}

@end
