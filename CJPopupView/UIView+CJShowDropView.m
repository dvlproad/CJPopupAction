//
//  UIView+CJShowDropView.m
//  CJPopupViewDemo
//
//  Created by 李超前 on 16/8/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "UIView+CJShowDropView.h"

static NSString *cjExtendViewKey = @"cjExtendView";
static NSString *cjShowInViewKey = @"cjShowInView";
static NSString *cjTapViewKey = @"cjTapView";

static NSString *cjShowExtendViewCompleteBlockKey = @"cjShowExtendViewCompleteBlock";
static NSString *cjHideExtendViewCompleteBlockKey = @"cjHideExtendViewCompleteBlock";
static NSString *cjTapBlankViewCompleteBlockKey = @"cjTapBlankViewCompleteBlock";

static NSString *cjExtendViewShowingKey = @"cjExtendViewShowing";

@interface UIView ()

@property (nonatomic, strong) UIView *cjExtendView; /**< 弹出视图 */
@property (nonatomic, strong) UIView *cjShowInView; /**< 弹出视图被add到的view */
@property (nonatomic, strong) UIView *cjTapView;    /**< 空白区域 */

@property (nonatomic, copy) CJTapBlankViewCompleteBlock cjTapBlankViewCompleteBlock;    /**< 点击空白区域执行的操作 */
@property (nonatomic, copy) CJShowExtendViewCompleteBlock cjShowExtendViewCompleteBlock;    /**< 显示弹出视图后的操作 */
@property (nonatomic, copy) CJHideExtendViewCompleteBlock cjHideExtendViewCompleteBlock;    /**< 隐藏弹出视图后的操作 */

@end

@implementation UIView (CJShowDropView)

#pragma mark - runtime
//cjExtendView
- (UIView *)cjExtendView {
    return objc_getAssociatedObject(self, &cjExtendViewKey);
}

- (void)setCjExtendView:(UIView *)cjExtendView {
    return objc_setAssociatedObject(self, &cjExtendViewKey, cjExtendView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//cjShowInView
- (UIView *)cjShowInView {
    return objc_getAssociatedObject(self, &cjShowInViewKey);
}

- (void)setCjShowInView:(UIView *)cjShowInView {
    return objc_setAssociatedObject(self, &cjShowInViewKey, cjShowInView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//cjTapView
- (UIView *)cjTapView {
    return objc_getAssociatedObject(self, &cjTapViewKey);
}

- (void)setCjTapView:(UIView *)cjTapView {
    return objc_setAssociatedObject(self, &cjTapViewKey, cjTapView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//cjTapBlankViewCompleteBlock
- (CJTapBlankViewCompleteBlock)cjTapBlankViewCompleteBlock {
    return objc_getAssociatedObject(self, &cjTapBlankViewCompleteBlockKey);
}

- (void)setCjTapBlankViewCompleteBlock:(CJTapBlankViewCompleteBlock)cjTapBlankViewCompleteBlock {
    return objc_setAssociatedObject(self, &cjTapBlankViewCompleteBlockKey, cjTapBlankViewCompleteBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//cjHideExtendViewCompleteBlock
- (CJHideExtendViewCompleteBlock)cjHideExtendViewCompleteBlock {
    return objc_getAssociatedObject(self, &cjHideExtendViewCompleteBlockKey);
}

- (void)setCjHideExtendViewCompleteBlock:(CJHideExtendViewCompleteBlock)cjHideExtendViewCompleteBlock {
    return objc_setAssociatedObject(self, &cjHideExtendViewCompleteBlockKey, cjHideExtendViewCompleteBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//cjShowExtendViewCompleteBlock
- (CJShowExtendViewCompleteBlock)cjShowExtendViewCompleteBlock {
    return objc_getAssociatedObject(self, &cjShowExtendViewCompleteBlockKey);
}

- (void)setCjShowExtendViewCompleteBlock:(CJShowExtendViewCompleteBlock)cjShowExtendViewCompleteBlock {
    return objc_setAssociatedObject(self, &cjShowExtendViewCompleteBlockKey, cjShowExtendViewCompleteBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//cjExtendViewShowing
- (BOOL)isCJExtendViewShowing {
    return [objc_getAssociatedObject(self, &cjExtendViewShowingKey) boolValue];
}

- (void)setCjExtendViewShowing:(BOOL)cjExtendViewShowing {
    return objc_setAssociatedObject(self, &cjExtendViewShowingKey, @(cjExtendViewShowing), OBJC_ASSOCIATION_ASSIGN);
}


/** 完整的描述请参见文件头部 */
- (void)cj_popupInView:(UIView *)showInView
       atLocationPoint:(CGPoint)location
              withSize:(CGSize)size
          showComplete:(CJShowExtendViewCompleteBlock)showExtendViewCompleteBlock
         tapBGComplete:(CJTapBlankViewCompleteBlock)tapBlankViewCompleteBlock
          hideComplete:(CJHideExtendViewCompleteBlock)hideExtendViewCompleteBlock {
    
    UIView *extendView = self;
    
    CGFloat extendViewX = location.x;
    CGFloat extendViewY = location.y;
    CGFloat extendViewWidth = size.width;
    CGFloat extendViewHeight = size.height;
    CGRect extendViewFrame = CGRectMake(extendViewX,
                                        extendViewY,
                                        extendViewWidth,
                                        extendViewHeight);
    
    CGFloat tapViewX = location.x;
    CGFloat tapViewY = location.y;
    CGFloat tapViewWidth = size.width;
    CGFloat tapViewHeight = CGRectGetHeight(showInView.frame) - CGRectGetMinY(extendViewFrame) - 10;
    CGRect tapViewFrame = CGRectMake(tapViewX, tapViewY, tapViewWidth, tapViewHeight);
    
    
    self.cjExtendViewShowing = YES;
    self.cjShowExtendViewCompleteBlock = showExtendViewCompleteBlock;
    self.cjHideExtendViewCompleteBlock = hideExtendViewCompleteBlock;
    self.cjTapBlankViewCompleteBlock = tapBlankViewCompleteBlock;
    
    if (self.cjExtendView) {
        [self.cjExtendView removeFromSuperview];
        [self.cjTapView removeFromSuperview];
    }
    
    
    //执行隐藏的手势视图
    self.cjExtendView = extendView;
    self.cjShowInView = showInView;
    
    if (!self.cjTapView) { //tapV是指radioButtons组合下的点击区域（不包括radioButtons区域），用来点击之后隐藏列表
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cj_TapViewTappedAction:)];
        
        
        self.cjTapView = [[UIView alloc] initWithFrame:tapViewFrame];
        self.cjTapView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5];
        [self.cjTapView addGestureRecognizer:tapGesture];
    }
    [self.cjShowInView addSubview:self.cjTapView];
    
    [self.cjShowInView addSubview:self.cjExtendView];
    
    //动画设置位置
    CGRect extendViewZeroFrame = extendViewFrame;
    extendViewZeroFrame.size.height = 0;
    self.cjExtendView.frame = extendViewZeroFrame;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.cjTapView.alpha = 0.2;
        self.cjExtendView.alpha = 0.2;
        
        self.cjTapView.alpha = 1.0;
        self.cjExtendView.alpha = 1.0;
        
        CGRect extendViewFrame = self.cjExtendView.frame;
        extendViewFrame.size.height = extendViewHeight;
        self.cjExtendView.frame = extendViewFrame;
    }];
    
    if(showExtendViewCompleteBlock){
        showExtendViewCompleteBlock();
    }
}

#pragma mark - <#Section#>
/** 完整的描述请参见文件头部 */
#pragma mark - <#Section#>
/** 完整的描述请参见文件头部 */
- (void)cj_popupInView:(UIView *)showInView
             underView:(UIView *)accordingView
          showComplete:(CJShowExtendViewCompleteBlock)showExtendViewCompleteBlock
         tapBGComplete:(CJTapBlankViewCompleteBlock)tapBlankViewCompleteBlock
          hideComplete:(CJHideExtendViewCompleteBlock)hideExtendViewCompleteBlock {
    
    UIView *extendView = self;
    
    //- (void)cj_showDropDownExtendView:(UIView *)extendView withShowInView:(UIView *)showInVIew completeBlock:(void(^)(void))completeBlock {
    
    //radioButtons在superView中对应的y、rect值为：
    CGRect accordingViewFrameInHisSuperView = [accordingView.superview convertRect:accordingView.frame toView:showInView];
    //第一个参数必须为所要转化的rect的视图的父视图，这里可以将父视图直接写出，也可用该视图的superview来替代，这样更方便
    //NSLog(@"rectInSuperView_self = %@", NSStringFromCGRect(rectInSuperView_self));
    
    CGFloat x = CGRectGetMinX(accordingView.frame);
    CGFloat y = CGRectGetMinY(accordingViewFrameInHisSuperView) + CGRectGetHeight(accordingView.frame);
    
    CGFloat extendViewWidth = CGRectGetWidth(extendView.frame);
    CGFloat extendViewHeight = CGRectGetHeight(extendView.frame);
    
    CGPoint locationPoint = CGPointMake(x, y);
    CGSize size_self = CGSizeMake(extendViewWidth, extendViewHeight);
    
    [extendView cj_popupInView:showInView atLocationPoint:locationPoint withSize:size_self showComplete:^{
        
    } tapBGComplete:^(UIView *view) {
        
    } hideComplete:^(UIView *view) {
        
    }];
}

- (void)cj_showDropDownExtendView:(UIView *)extendView withShowInView:(UIView *)showInVIew completeBlock:(void(^)(void))completeBlock {
    
    //radioButtons在superView中对应的y、rect值为：
    CGRect rectInSuperView_self = [self.superview convertRect:self.frame toView:showInVIew];
    //第一个参数必须为所要转化的rect的视图的父视图，这里可以将父视图直接写出，也可用该视图的superview来替代，这样更方便
    //NSLog(@"rectInSuperView_self = %@", NSStringFromCGRect(rectInSuperView_self));
    
    CGFloat x = self.frame.origin.x;
    CGFloat y = rectInSuperView_self.origin.y + self.frame.size.height;
    CGFloat extendViewWidth = CGRectGetWidth(extendView.frame);
    CGFloat extendViewHeight = CGRectGetHeight(extendView.frame);
    
    CGPoint locationPoint = CGPointMake(x, y);
    CGSize size_self = CGSizeMake(extendViewWidth, extendViewHeight);
    
    [extendView cj_popupInView:showInVIew atLocationPoint:locationPoint withSize:size_self showComplete:^{
        
    } tapBGComplete:^(UIView *view) {
        
    } hideComplete:^(UIView *view) {
        
    }];
}

- (void)cj_TapViewTappedAction:(UITapGestureRecognizer *)tap {
    if (self.cjTapBlankViewCompleteBlock) {
        self.cjTapBlankViewCompleteBlock(self);
    } else {
        NSLog(@"未设置cjTapViewTappedAction");
    }
    [self cj_hideDropDownExtendView];
}


/** 完整的描述请参见文件头部 */
- (void)cj_hideDropDownExtendView {
    self.cjExtendViewShowing = NO;  //设置成NO表示当前未显示任何弹出视图
    
    CGRect rect = self.cjExtendView.frame;
    rect.size.height = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.cjTapView.alpha = 1.0f;
        self.cjExtendView.alpha = 1.0f;
        
        //要设置成0，不设置非零值如0.2，是为了防止在显示出来的时候，在0.3秒内很快按两次按钮，仍有view存在
        self.cjTapView.alpha = 0.0f;
        self.cjExtendView.alpha = 0.0f;
        
        self.cjExtendView.frame = rect;
    }completion:^(BOOL finished) {
        [self.cjExtendView removeFromSuperview];
        [self.cjTapView removeFromSuperview];
    }];
    
    
    if (self.cjHideExtendViewCompleteBlock) {
        self.cjHideExtendViewCompleteBlock(self);
    }
}

@end
