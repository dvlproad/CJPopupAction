//
//  UIView+CJPopupInView.m
//  CJPopupViewDemo
//
//  Created by lichq on 15/11/12.
//  Copyright (c) 2015年 ciyouzen. All rights reserved.
//

#import "UIView+CJPopupInView.h"

static NSString *cjShowInViewKey = @"cjShowInView";
static NSString *cjTapViewKey = @"cjTapView";

static NSString *cjShowPopupViewCompleteBlockKey = @"cjShowPopupViewCompleteBlock";
static NSString *cjHidePopupViewCompleteBlockKey = @"cjHidePopupViewCompleteBlock";
static NSString *cjTapBlankViewCompleteBlockKey = @"cjTapBlankViewCompleteBlock";

static NSString *cjPopupViewShowingKey = @"cjPopupViewShowing";

@interface UIView ()

@property (nonatomic, strong) UIView *cjShowInView; /**< 弹出视图被add到的view */
@property (nonatomic, strong) UIView *cjTapView;    /**< 空白区域 */

@property (nonatomic, copy) CJTapBlankViewCompleteBlock cjTapBlankViewCompleteBlock;    /**< 点击空白区域执行的操作 */
@property (nonatomic, copy) CJShowPopupViewCompleteBlock cjShowPopupViewCompleteBlock;    /**< 显示弹出视图后的操作 */
@property (nonatomic, copy) CJHidePopupViewCompleteBlock cjHidePopupViewCompleteBlock;    /**< 隐藏弹出视图后的操作 */

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
- (CJTapBlankViewCompleteBlock)cjTapBlankViewCompleteBlock {
    return objc_getAssociatedObject(self, &cjTapBlankViewCompleteBlockKey);
}

- (void)setCjTapBlankViewCompleteBlock:(CJTapBlankViewCompleteBlock)cjTapBlankViewCompleteBlock {
    return objc_setAssociatedObject(self, &cjTapBlankViewCompleteBlockKey, cjTapBlankViewCompleteBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//cjShowPopupViewCompleteBlock
- (CJShowPopupViewCompleteBlock)cjShowPopupViewCompleteBlock {
    return objc_getAssociatedObject(self, &cjShowPopupViewCompleteBlockKey);
}

- (void)setCjShowPopupViewCompleteBlock:(CJShowPopupViewCompleteBlock)cjShowPopupViewCompleteBlock {
    return objc_setAssociatedObject(self, &cjShowPopupViewCompleteBlockKey, cjShowPopupViewCompleteBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//cjHidePopupViewCompleteBlock
- (CJHidePopupViewCompleteBlock)cjHidePopupViewCompleteBlock {
    return objc_getAssociatedObject(self, &cjHidePopupViewCompleteBlockKey);
}

- (void)setCjHidePopupViewCompleteBlock:(CJHidePopupViewCompleteBlock)cjHidePopupViewCompleteBlock {
    return objc_setAssociatedObject(self, &cjHidePopupViewCompleteBlockKey, cjHidePopupViewCompleteBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


//cjPopupViewShowing
- (BOOL)isCJPopupViewShowing {
    return [objc_getAssociatedObject(self, &cjPopupViewShowingKey) boolValue];
}

- (void)setCjPopupViewShowing:(BOOL)cjPopupViewShowing {
    return objc_setAssociatedObject(self, &cjPopupViewShowingKey, @(cjPopupViewShowing), OBJC_ASSOCIATION_ASSIGN);
}


#pragma mark - 底层接口
/** 完整的描述请参见文件头部 */
- (void)cj_popupInView:(UIView *)popupSuperView
            atLocation:(CGPoint)location
              withSize:(CGSize)size
          showComplete:(CJShowPopupViewCompleteBlock)showPopupViewCompleteBlock
      tapBlankComplete:(CJTapBlankViewCompleteBlock)tapBlankViewCompleteBlock
          hideComplete:(CJHidePopupViewCompleteBlock)hidePopupViewCompleteBlock {
    
    UIView *popupView = self;
    
    CGFloat popupViewX = location.x;
    CGFloat popupViewY = location.y;
    CGFloat popupViewWidth = size.width;
    CGFloat popupViewHeight = size.height;
    CGRect popupViewFrame = CGRectMake(popupViewX,
                                       popupViewY,
                                       popupViewWidth,
                                       popupViewHeight);
    
    CGFloat tapViewX = location.x;
    CGFloat tapViewY = location.y;
    CGFloat tapViewWidth = size.width;
    CGFloat tapViewHeight = CGRectGetHeight(popupSuperView.frame) - CGRectGetMinY(popupViewFrame) - 10;
    CGRect tapViewFrame = CGRectMake(tapViewX, tapViewY, tapViewWidth, tapViewHeight);
    
    
    self.cjPopupViewShowing = YES;
    self.cjShowPopupViewCompleteBlock = showPopupViewCompleteBlock;
    self.cjHidePopupViewCompleteBlock = hidePopupViewCompleteBlock;
    self.cjTapBlankViewCompleteBlock = tapBlankViewCompleteBlock;
    

    if (self.cjTapView) {
        [self.cjTapView removeFromSuperview];
        [popupView removeFromSuperview];
    }
    
    
    //执行隐藏的手势视图
    UIView *tapView = self.cjTapView;
    if (tapView == nil) { //tapV是指radioButtons组合下的点击区域（不包括radioButtons区域），用来点击之后隐藏列表
        tapView = [[UIView alloc] initWithFrame:tapViewFrame];
        tapView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cj_TapBlankViewAction:)];
        [tapView addGestureRecognizer:tapGesture];
    }
    [popupSuperView addSubview:tapView];
    [popupSuperView addSubview:popupView];
    
    self.cjShowInView = popupSuperView;
    self.cjTapView = tapView;
    
    //动画设置位置
    CGRect popupViewZeroFrame = popupViewFrame;
    popupViewZeroFrame.size.height = 0;
    popupView.frame = popupViewZeroFrame;
    
    [UIView animateWithDuration:0.3 animations:^{
        tapView.alpha = 0.2;
        popupView.alpha = 0.2;
        
        tapView.alpha = 1.0;
        popupView.alpha = 1.0;
        
        CGRect popupViewFrame = popupView.frame;
        popupViewFrame.size.height = popupViewHeight;
        popupView.frame = popupViewFrame;
    }];
    
    if(showPopupViewCompleteBlock){
        showPopupViewCompleteBlock();
    }
}

/** 点击空白区域的事件 */
- (void)cj_TapBlankViewAction:(UITapGestureRecognizer *)tap {
    if (self.cjTapBlankViewCompleteBlock) {
        self.cjTapBlankViewCompleteBlock();
    } else {
        NSLog(@"未设置cjTapViewTappedAction");
    }
    [self cj_hidePopupViewAnimated:YES];
}


/** 完整的描述请参见文件头部 */
- (void)cj_hidePopupViewAnimated:(BOOL)animated {
    self.cjPopupViewShowing = NO;  //设置成NO表示当前未显示任何弹出视图
    
    UIView *popupView = self;
    UIView *tapView = self.cjTapView;
    
    CGRect popupViewFrame = popupView.frame;
    popupViewFrame.size.height = 0;
    

    if (animated == NO) {
        [popupView removeFromSuperview];
        [tapView removeFromSuperview];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            tapView.alpha = 1.0f;
            popupView.alpha = 1.0f;
            
            //要设置成0，不设置非零值如0.2，是为了防止在显示出来的时候，在0.3秒内很快按两次按钮，仍有view存在
            tapView.alpha = 0.0f;
            popupView.alpha = 0.0f;
            
            popupView.frame = popupViewFrame;
        }completion:^(BOOL finished) {
            [popupView removeFromSuperview];
            [tapView removeFromSuperview];
        }];
    }
    
    if (self.cjHidePopupViewCompleteBlock) {
        self.cjHidePopupViewCompleteBlock();
    }
}




@end
