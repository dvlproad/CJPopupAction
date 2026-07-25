//
//  UIView+CJPopupInView.m
//  CJPopupAction
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJPopupInView.h"
#import "CJPopupCalculator.h"

#define CJPopupMainThreadAssert() NSAssert([NSThread isMainThread], @"UIView+CJPopupInView needs to be accessed on the main thread.");

static CGFloat kCJPopupAnimationDuration = 0.3;

static NSString *cjPopupAnimationTypeKey = @"cjPopupAnimationType";
static NSString *cjPopupViewHideFrameStringKey = @"cjPopupViewHideFrameString";
static NSString *cjPopupViewHideTransformKey = @"cjPopupViewHideTransform";

static NSString *cjShowInViewKey = @"cjShowInView";
static NSString *cjTapViewKey = @"cjTapView";

static NSString *cjShowPopupViewCompleteBlockKey = @"cjShowPopupViewCompleteBlock";
static NSString *cjTapBlankViewCompleteBlockKey = @"cjTapBlankViewCompleteBlock";

static NSString *cjPopupViewShowingKey = @"cjPopupViewShowing";
static NSString *cjMustHideFromPopupViewKey = @"cjMustHideFromPopupView";


@interface UIView ()

@property (nonatomic, assign) CJAnimationType cjPopupAnimationType; /**< 弹出视图的动画方式 */
@property (nonatomic, copy) NSString *cjPopupViewHideFrameString;   /**< 弹出视图隐藏时候的frame */
//@property (nonatomic, assign) CATransform3D cjPopupViewHideTransform;/**< 弹出视图隐藏时候的transform */

@property (nonatomic, strong) UIView *cjShowInView; /**< 弹出视图被add到的view */
@property (nonatomic, strong) UIView *cjTapView;    /**< 空白区域（指radioButtons组合下的点击区域（不包括radioButtons区域），用来点击之后隐藏列表） */

@property (nonatomic, copy) void(^cjTapBlankViewCompleteBlock)(void);   /**< 点击空白区域执行的操作 */
@property (nonatomic, copy) void(^cjShowPopupViewCompleteBlock)(void);  /**< 显示弹出视图后的操作 */

@end


@implementation UIView (CJPopupInView)

#pragma mark - runtime
//cjPopupAnimationType
- (CJAnimationType)cjPopupAnimationType {
    return [objc_getAssociatedObject(self, &cjPopupAnimationTypeKey) integerValue];
}

- (void)setCjPopupAnimationType:(CJAnimationType)cjPopupAnimationType {
    return objc_setAssociatedObject(self, &cjPopupAnimationTypeKey, @(cjPopupAnimationType), OBJC_ASSOCIATION_ASSIGN);
}

//cjPopupViewHideFrameString
- (NSString *)cjPopupViewHideFrameString {
    return objc_getAssociatedObject(self, &cjPopupViewHideFrameStringKey);
}

- (void)setCjPopupViewHideFrameString:(NSString *)cjPopupViewHideFrameString {
    return objc_setAssociatedObject(self, &cjPopupViewHideFrameStringKey, cjPopupViewHideFrameString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

////cjPopupViewHideTransform
//- (CATransform3D)cjPopupViewHideTransform {
//    return objc_getAssociatedObject(self, &cjPopupViewHideTransformKey);
//}
//
//- (void)setCjPopupViewHideTransform:(CATransform3D)cjPopupViewHideTransform {
//    return objc_setAssociatedObject(self, &cjPopupViewHideTransformKey, cjPopupViewHideTransform, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

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

#pragma mark - 底层接口
/** 完整的描述请参见文件头部 */
- (void)cj_popupInView:(UIView *)popupSuperview
            withOrigin:(CGPoint)popupViewOrigin
                  size:(CGSize)popupViewSize
          blankBGModel:(nullable CJPopupBlankModel *)blankBGModel
//        popupRectModel:(CJPopupRectModel *)popupRectModel
          showComplete:(void(^)(void))showPopupViewCompleteBlock
      tapBlankComplete:(void(^)(void))tapBlankViewCompleteBlock
{
    CJPopupMainThreadAssert();
    
    UIView *popupView = self;
    
    BOOL canAdd = [self letPopupSuperview:popupSuperview addPopupView:popupView withBlankBGModel:blankBGModel];
    if (!canAdd) {
        return;
    }
    
    if (self.cjTapView != nil) { // 如果之前没创建 blankBG 视图，则不需要设置其frame
        UIView *blankView = self.cjTapView;
        CGFloat blankViewY = popupViewOrigin.y;
        CGFloat blankViewHeight = CGRectGetHeight(popupSuperview.frame) - popupViewOrigin.y;
        CGFloat blankViewX = blankBGModel.x > 0 ? blankBGModel.x : 0;
        CGFloat blankViewWidth = blankBGModel.width > 0 ? blankBGModel.width : CGRectGetWidth(popupSuperview.frame);
        CGRect blankViewFrame = CGRectMake(blankViewX,
                                           blankViewY,
                                           blankViewWidth,
                                           blankViewHeight);
        [blankView setFrame:blankViewFrame];
    }
    

    self.cjPopupAnimationType = CJAnimationTypeNormal;
    self.cjShowPopupViewCompleteBlock = showPopupViewCompleteBlock;
    self.cjTapBlankViewCompleteBlock = tapBlankViewCompleteBlock;
    
    CJPopupFramePair pair = [CJPopupCalculator expandToDownFromLeftTop:popupViewOrigin size:popupViewSize];
    self.cjPopupViewHideFrameString = NSStringFromCGRect(pair.hideFrame);
    [self cj_showExpandViewWithShowFrame:pair.showFrame hideFrame:pair.hideFrame showComplete:showPopupViewCompleteBlock];
}

/* 完整的描述请参见文件头部 */
- (void)cj_popupInCenterWindow:(CJAnimationType)animationType
                      withSize:(CGSize)popupViewSize
                  blankBGColor:(nullable UIColor *)blankBGColor
                  showComplete:(void(^)(void))showPopupViewCompleteBlock
              tapBlankComplete:(void(^)(void))tapBlankViewCompleteBlock
{
    CJPopupMainThreadAssert();
    
    // 弹出在window的中间或底部的不能没有 blankBG 视图，所以强制创建 blankBGModel 来让保证后续能创建出 blankBG 视图
    CJPopupBlankModel *blankBGModel = blankBGColor != nil ? [CJPopupBlankModel modelWidthColor:blankBGColor] : [CJPopupBlankModel defaultModel];
    NSAssert(blankBGModel != nil, @"弹出到window时候，blankBGModel 不能为 nil");
    
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    UIView *popupView = self;
    UIView *popupSuperview = keyWindow;
    
    NSAssert(popupViewSize.width != 0 && popupViewSize.height != 0, @"弹出视图的宽高都不能为0");
    CGRect frame = popupView.frame;
    frame.size.width = popupViewSize.width;
    frame.size.height = popupViewSize.height;
    popupView.frame = frame;
    
    BOOL canAdd = [self letkeyWindowAddPopupView:popupView withBlankBGModel:blankBGModel];
    if (!canAdd) {
        return;
    }
    
    
    self.cjPopupAnimationType = animationType;
    self.cjShowPopupViewCompleteBlock = showPopupViewCompleteBlock;
    self.cjTapBlankViewCompleteBlock = tapBlankViewCompleteBlock;
    
    CJPopupFramePair pair = [CJPopupCalculator expandToCenterFromCenter:popupSuperview.center size:popupViewSize];
    self.cjPopupViewHideFrameString = NSStringFromCGRect(pair.hideFrame);
    [self cj_showExpandViewWithShowFrame:pair.showFrame hideFrame:pair.hideFrame showComplete:showPopupViewCompleteBlock];
}
/** 完整的描述请参见文件头部 */
- (void)cj_popupInBottomWindow:(CJAnimationType)animationType
                    withHeight:(CGFloat)popupViewHeight
                    edgeInsets:(UIEdgeInsets)edgeInsets
                  blankBGColor:(nullable UIColor *)blankBGColor
                  showComplete:(void(^)(void))showPopupViewCompleteBlock
              tapBlankComplete:(void(^)(void))tapBlankViewCompleteBlock
{
    CJPopupMainThreadAssert();
    NSAssert(popupViewHeight != 0, @"弹出视图的高都不能为0");
    
    // 弹出在window的中间或底部的不能没有 blankBG 视图，所以强制创建 blankBGModel 来让保证后续能创建出 blankBG 视图
    CJPopupBlankModel *blankBGModel = blankBGColor != nil ? [CJPopupBlankModel modelWidthColor:blankBGColor] : [CJPopupBlankModel defaultModel];
    NSAssert(blankBGModel != nil, @"弹出到window时候，blankBGModel 不能为 nil");
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGFloat popupViewWidth = CGRectGetWidth(keyWindow.frame) - edgeInsets.left - edgeInsets.right;
    CGSize popupViewSize = CGSizeMake(popupViewWidth, popupViewHeight);
    if (CGSizeEqualToSize(self.frame.size, popupViewSize)) {
        NSLog(@"Warning:popupView视图大小将自动调整为指定的弹出视图大小");
        CGRect selfFrame = self.frame;
        selfFrame.size = popupViewSize;
        self.frame = selfFrame;
    }
    
    UIView *popupView = self;
    
    BOOL canAdd = [self letkeyWindowAddPopupView:popupView withBlankBGModel:blankBGModel];
    if (!canAdd) {
        return;
    }
    
    
    
    self.cjPopupAnimationType = animationType;
    self.cjShowPopupViewCompleteBlock = showPopupViewCompleteBlock;
    self.cjTapBlankViewCompleteBlock = tapBlankViewCompleteBlock;

    
    //popupViewShowFrame
    CGFloat popupViewX = edgeInsets.left;
    CGFloat popupViewShowY = CGRectGetHeight(keyWindow.frame) - popupViewHeight - edgeInsets.bottom;
    CGRect popupViewShowFrame = CGRectZero;
    popupViewShowFrame = CGRectMake(popupViewX,
                                    popupViewShowY,
                                    popupViewWidth,
                                    popupViewHeight);
    
    if (animationType == CJAnimationTypeNone) {
        popupView.frame = popupViewShowFrame;
        !showPopupViewCompleteBlock ?: showPopupViewCompleteBlock();
        
    } else if (animationType == CJAnimationTypeNormal) {
        //popupViewHideFrame
        CGRect popupViewHideFrame = popupViewShowFrame;
        popupViewHideFrame.origin.y = CGRectGetMaxY(keyWindow.frame);
        self.cjPopupViewHideFrameString = NSStringFromCGRect(popupViewHideFrame);
        
        //动画设置位置
        UIView *blankView = self.cjTapView;
        blankView.alpha = 0.2;
        popupView.alpha = 0.2;
        popupView.frame = popupViewHideFrame;
        [UIView animateWithDuration:kCJPopupAnimationDuration animations:^{
             blankView.alpha = 1.0;
             popupView.alpha = 1.0;
             popupView.frame = popupViewShowFrame;
        } completion:^(BOOL finished) {
            !showPopupViewCompleteBlock ?: showPopupViewCompleteBlock();
        }];
        
    } else if (animationType == CJAnimationTypeCATransform3D) {
        popupView.frame = popupViewShowFrame;
        
        CATransform3D popupViewShowTransform = CATransform3DIdentity;
        
        CATransform3D rotate = CATransform3DMakeRotation(70.0*M_PI/180.0, 0.0, 0.0, 1.0);
        CATransform3D translate = CATransform3DMakeTranslation(20.0, -500.0, 0.0);
        CATransform3D popupViewHideTransform = CATransform3DConcat(rotate, translate);
        
        self.layer.transform = popupViewHideTransform;
        [UIView animateWithDuration:kCJPopupAnimationDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.layer.transform = popupViewShowTransform;
                         } completion:^(BOOL finished) {
                             !showPopupViewCompleteBlock ?: showPopupViewCompleteBlock();
                         }];
    }
}


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
         withBlankBGModel:(CJPopupBlankModel *)blankBGModel
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


/** 完整的描述请参见文件头部 */
- (void)cj_hidePopupView {
    CJAnimationType animationType = self.cjPopupAnimationType;
    [self cj_hidePopupViewWithAnimationType:animationType];
}

#pragma mark - 底层内部方法
- (void)cj_showSlideViewFromDirection:(CJSlideFromDirection)direction
                               offset:(CGFloat)offset
                            showFrame:(CGRect)popupViewShowFrame
{
    UIView *popupView = self;
    UIView *blankView = self.cjTapView;
    
    CGAffineTransform hideTransform = [CJPopupCalculator slideHideTransformWithDirection:direction offset:offset];
    
    popupView.frame = popupViewShowFrame;
    popupView.transform = hideTransform;
    blankView.alpha = 0.2;
    popupView.alpha = 0.2;
    [UIView animateWithDuration:kCJPopupAnimationDuration
                     animations:^{
                         blankView.alpha = 1.0;
                         popupView.alpha = 1.0;
                         popupView.transform = CGAffineTransformIdentity;
                     }];
}

- (void)cj_showExpandViewWithShowFrame:(CGRect)popupViewShowFrame
                             hideFrame:(CGRect)popupViewHideFrame
                          showComplete:(void(^)(void))showPopupViewCompleteBlock
{
    UIView *blankView = self.cjTapView;
    if (blankView != nil) {
        blankView.alpha = 0.2;
    }
    UIView *popupView = self;
    popupView.frame = popupViewHideFrame;
    popupView.alpha = 0.2;
    [UIView animateWithDuration:kCJPopupAnimationDuration animations:^{
        if (blankView != nil) {
            blankView.alpha = 1.0;
        }
        popupView.alpha = 1.0;
        popupView.frame = popupViewShowFrame;
    } completion:^(BOOL finished) {
        !showPopupViewCompleteBlock ?: showPopupViewCompleteBlock();
    }];
}

/** 完整的描述请参见文件头部 */
- (void)cj_hidePopupViewWithAnimationType:(CJAnimationType)animationType {
    CJPopupMainThreadAssert();
    
    self.cjPopupViewShowing = NO;  //设置成NO表示当前未显示任何弹出视图
    [self endEditing:YES];
    
    UIView *popupView = self;
    UIView *tapView = self.cjTapView;
    
    switch (animationType) {
        case CJAnimationTypeNone:
        {
            [popupView removeFromSuperview];
            [tapView removeFromSuperview];
            break;
        }
        case CJAnimationTypeNormal:
        {
            CGRect popupViewHideFrame = CGRectFromString(self.cjPopupViewHideFrameString);
            if (CGRectEqualToRect(popupViewHideFrame, CGRectZero)) {
                popupViewHideFrame = self.frame;
            }
            
            [UIView animateWithDuration:kCJPopupAnimationDuration
                             animations:^{
                                 //要设置成0，不设置非零值如0.2，是为了防止在显示出来的时候，在0.3秒内很快按两次按钮，仍有view存在
                                 tapView.alpha = 0.0f;
                                 popupView.alpha = 0.0f;
                                 popupView.frame = popupViewHideFrame;
                                 
                             }completion:^(BOOL finished) {
                                 [popupView removeFromSuperview];
                                 [tapView removeFromSuperview];
                             }];
            break;
        }
        case CJAnimationTypeCATransform3D:
        {
            [UIView animateWithDuration:kCJPopupAnimationDuration
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 CATransform3D rotate = CATransform3DMakeRotation(-70.0 * M_PI / 180.0, 0.0, 0.0, 1.0);
                                 CATransform3D translate = CATransform3DMakeTranslation(-20.0, 500.0, 0.0);
                                 popupView.layer.transform = CATransform3DConcat(rotate, translate);
                                 
                             } completion:^(BOOL finished) {
                                 [popupView removeFromSuperview];
                                 [tapView removeFromSuperview];
                             }];
            break;
        }
    }
}

#pragma mark - ExtendView
/** 完整的描述请参见文件头部 */
- (void)cj_expandInView:(UIView *)popupSuperview
  locationAccordingView:(UIView *)accordingView
       relativePosition:(CJPopupViewPosition)popupViewPosition
           blankBGModel:(nullable CJPopupBlankModel *)blankBGModel
           showComplete:(void(^)(void))showPopupViewCompleteBlock
       tapBlankComplete:(void(^)(void))tapBlankViewCompleteBlock
{
    NSAssert(accordingView != nil, @"accordingView不能为空");
    
    UIView *popupView = self;
    
    CGSize popupViewSize = CGSizeMake(CGRectGetWidth(accordingView.frame), CGRectGetHeight(popupView.frame));
    NSAssert(popupViewSize.height != 0, @"弹出视图的高度不能为0");
    
    CGRect accordingFrame = [accordingView.superview convertRect:accordingView.frame toView:popupSuperview];
    CGFloat x = CGRectGetMinX(accordingFrame);
    CGFloat y = CGRectGetMinY(accordingFrame);
    CGFloat w = CGRectGetWidth(accordingFrame);
    CGFloat h = CGRectGetHeight(accordingFrame);
    
    CJPopupFramePair pair;
    switch (popupViewPosition) {
        case CJPopupViewPositionBelow:
            pair = [CJPopupCalculator expandToDownFromLeftTop:CGPointMake(x, y + h) size:popupViewSize];
            break;
        case CJPopupViewPositionAbove:
            pair = [CJPopupCalculator expandToUpFromLeftBottom:CGPointMake(x, y) size:popupViewSize];
            break;
        case CJPopupViewPositionCenter:
            pair = [CJPopupCalculator expandToCenterFromCenter:CGPointMake(x + w / 2.0, y + h / 2.0) size:popupViewSize];
            break;
    }
    
    CJPopupMainThreadAssert();
    
    BOOL canAdd = [popupView letPopupSuperview:popupSuperview addPopupView:popupView withBlankBGModel:blankBGModel];
    if (!canAdd) {
        return;
    }
    
    popupView.cjShowPopupViewCompleteBlock = showPopupViewCompleteBlock;
    popupView.cjTapBlankViewCompleteBlock = tapBlankViewCompleteBlock;
    
    popupView.cjPopupViewHideFrameString = NSStringFromCGRect(pair.hideFrame);
    [popupView cj_showExpandViewWithShowFrame:pair.showFrame hideFrame:pair.hideFrame showComplete:showPopupViewCompleteBlock];
}


@end
