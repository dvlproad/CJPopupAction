//
//  CQTSBottomBlankView.m
//  CQDemoKit
//
//  Created by ciyouzen on 2026/08/04.
//

#import "CQTSBottomBlankView.h"

#import <Masonry/Masonry.h>
#import "CQTSBlankPresenter.h"

@interface CQTSBottomBlankView () {
    
}
@property (nonatomic, copy) void(^ _Nullable tapBlankHandle)(CQTSBottomBlankView *bBlankView);

@end

@implementation CQTSBottomBlankView

#pragma mark - Init
/*
 *  初始化包含popupView的【底部完整弹出框视图】（内容视图左右铺满容器）
 *
 *  @param popupView            弹出视图的内容视图
 *  @param popupViewHeight      弹出视图的高度
 */
- (instancetype)initWithPopupView:(UIView *)popupView
                  popupViewHeight:(CGFloat)popupViewHeight
                 tapBlankComplete:(void(^ _Nullable)(CQTSBottomBlankView *bBlankView))tapBlankComplete
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _popupView = popupView;
        _popupViewHeight = popupViewHeight;
        _tapBlankHandle = tapBlankComplete;

        _blankPresenter = [[CQTSBlankPresenter alloc] init];
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];   // 半透明遮罩，对齐原版默认
        
        // 用 button 处理点击空白（而非手势），避免 popupView 上含 tableView/collectionView 时点击 cell 被拦截
        UIButton *tapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tapButton addTarget:self action:@selector(tapBlankAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tapButton];
        [tapButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addSubview:popupView];
        [popupView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(popupViewHeight);
            make.bottom.equalTo(self).mas_offset(popupViewHeight);   // 初始藏于屏下
        }];
    }
    return self;
}

#pragma mark - Show & Hide
/*
 *  显示弹窗（默认显示在 keyWindow 上，内部委托给 blankPresenter 执行）
 *
 *  @param blankSuperview  要显示在什么视图上（传 nil 表示 keyWindow）
 *  @param showComplete    显示动画完成的回调
 */
- (void)showBlankViewInView:(nullable UIView *)blankSuperview
                   complete:(void(^ _Nullable)(void))showComplete {
    [self.blankPresenter showBlankView:self inView:blankSuperview complete:showComplete];
}

/*
 *  隐藏弹窗（幂等，可多次调用，内部委托给 blankPresenter 执行）
 */
- (void)hideBlankView {
    [self.blankPresenter hideBlankView:self];
}

#pragma mark - CQTSBlankViewProtocol
/*
 *  更新约束，根据是否显示popupView
 *
 *  @param show     是否显示popupView
 */
- (void)updateConstraintsForPopupViewWithShow:(BOOL)show {
    [self.popupView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (show) {
            make.bottom.equalTo(self);
        } else {
            make.bottom.equalTo(self).mas_offset(self.popupViewHeight);
        }
    }];
}

#pragma mark - Get Method
/// 通过 popupView 获取到其所在的 popupView 容器，常用于 popupView 中的点击需要让容器隐藏等动作
+ (nullable CQTSBottomBlankView *)blankViewFromPopupView:(UIView *)popupView {
    for (UIView *superview = popupView.superview;
         superview != nil;
         superview = superview.superview) {
        if ([superview isKindOfClass:[CQTSBottomBlankView class]]) {
            return (CQTSBottomBlankView *)superview;
        }
    }
    return nil;
}

#pragma mark - Private Method
- (void)tapBlankAction {
    if (self.tapBlankHandle != nil) {
        self.tapBlankHandle(self);
    }
}

@end
