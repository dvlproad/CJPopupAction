//
//  UIView+CJPopupInView.m
//  CJPopupAction
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJPopupInView.h"

static NSString *cjShowInViewKey = @"cjShowInView";
static NSString *cjTapViewKey = @"cjTapView";

static NSString *cjShowPopupViewCompleteBlockKey = @"cjShowPopupViewCompleteBlock";
static NSString *cjTapBlankViewCompleteBlockKey = @"cjTapBlankViewCompleteBlock";

static NSString *cjPopupViewShowingKey = @"cjPopupViewShowing";
static NSString *cjMustHideFromPopupViewKey = @"cjMustHideFromPopupView";

// expand 的时候需要
static NSString *cjPopupViewHideFrameStringKey = @"cjPopupViewHideFrameString";

@interface UIView () {
    
}

@end


@implementation UIView (CJPopupInView)

#pragma mark - runtime
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
- (void(^)(void))cjTapBlankViewCompleteBlock {
    return objc_getAssociatedObject(self, &cjTapBlankViewCompleteBlockKey);
}

- (void)setCjTapBlankViewCompleteBlock:(void(^)(void))cjTapBlankViewCompleteBlock {
    return objc_setAssociatedObject(self, &cjTapBlankViewCompleteBlockKey, cjTapBlankViewCompleteBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//cjShowPopupViewCompleteBlock
- (void(^)(void))cjShowPopupViewCompleteBlock {
    return objc_getAssociatedObject(self, &cjShowPopupViewCompleteBlockKey);
}

- (void)setCjShowPopupViewCompleteBlock:(void(^)(void))cjShowPopupViewCompleteBlock {
    return objc_setAssociatedObject(self, &cjShowPopupViewCompleteBlockKey, cjShowPopupViewCompleteBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


//cjPopupViewShowing
- (BOOL)isCJPopupViewShowing {
    return [objc_getAssociatedObject(self, &cjPopupViewShowingKey) boolValue];
}

- (void)setCjPopupViewShowing:(BOOL)cjPopupViewShowing {
    return objc_setAssociatedObject(self, &cjPopupViewShowingKey, @(cjPopupViewShowing), OBJC_ASSOCIATION_ASSIGN);
}



//cjPopupViewHideFrameString
- (NSString *)cjPopupViewHideFrameString {
    return objc_getAssociatedObject(self, &cjPopupViewHideFrameStringKey);
}

- (void)setCjPopupViewHideFrameString:(NSString *)cjPopupViewHideFrameString {
    return objc_setAssociatedObject(self, &cjPopupViewHideFrameStringKey, cjPopupViewHideFrameString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Public Method
/**
 *  将popupView添加进keyWindow中(会默认添加进blankView及对popupView做一些默认设置)
 *
 *  @param popupView                要被添加的视图
 *  @param blankBGModel             空白遮罩模型
 *
 *  @return 是否可以被添加成功
 */
- (BOOL)letkeyWindowAddPopupView:(UIView *)popupView withBlankBGModel:(nullable CJPopupBlankModel *)blankBGModel
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    BOOL canAdd = [self letPopupSuperview:keyWindow addPopupView:popupView withBlankBGModel:blankBGModel];
    if (!canAdd) {
        return NO;
    }
    
    /* 设置blankView的位置 */
    UIView *blankView = self.cjTapView;
    CGFloat blankViewX = 0;
    CGFloat blankViewY = 0;
    CGFloat blankViewWidth = CGRectGetWidth(keyWindow.frame);
    CGFloat blankViewHeight = CGRectGetHeight(keyWindow.frame);;
    CGRect blankViewFrame = CGRectMake(blankViewX,
                                       blankViewY,
                                       blankViewWidth,
                                       blankViewHeight);
    [blankView setFrame:blankViewFrame];
    
    return YES;
}

/**
 *  将popupView添加进popupSuperview中(会默认添加进blankView及对popupView做一些默认设置)
 *
 *  @param popupSuperview           被添加到的地方
 *  @param popupView                要被添加的视图
 *  @param blankBGModel             空白遮罩模型（nil则不添加遮罩）
 *
 *  @return 是否可以被添加成功
 */
- (BOOL)letPopupSuperview:(UIView *)popupSuperview
             addPopupView:(UIView *)popupView
         withBlankBGModel:(nullable CJPopupBlankModel *)blankBGModel
{
    if ([popupSuperview.subviews containsObject:popupView]) {
        return NO;
    }
    
    if (blankBGModel != nil) { // 没设置blankBGModel的时候，当作不需要添加 blankBG 视图
        /* 添加进空白的点击区域blankView */
        UIView *blankView = self.cjTapView;
        if (blankView == nil) {
            blankView = [[UIView alloc] initWithFrame:CGRectZero];
            if (blankBGModel.color == nil) {
                blankView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.6];
            } else {
                blankView.backgroundColor = blankBGModel.color;
            }
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cj_TapBlankViewAction:)];
            [blankView addGestureRecognizer:tapGesture];
            
            self.cjTapView = blankView;
        }
        
        if (self.cjPopupViewShowing) { //如果存在，先清除
            [blankView removeFromSuperview];
        }
        [popupSuperview addSubview:blankView];
    }
    
    
    
    
    /* 添加进popupView，并做一些默认设置 */
    if (self.cjPopupViewShowing) { //如果存在，先清除
        [popupView removeFromSuperview];
    }
    [popupSuperview addSubview:popupView];
    
    self.cjShowInView = popupSuperview;
    self.cjPopupViewShowing = YES;
    
    return YES;
}


/** 点击空白区域的事件 */
- (void)cj_TapBlankViewAction:(UITapGestureRecognizer *)tap {
    if (self.cjTapBlankViewCompleteBlock) {
        self.cjTapBlankViewCompleteBlock();
    }
}



@end
