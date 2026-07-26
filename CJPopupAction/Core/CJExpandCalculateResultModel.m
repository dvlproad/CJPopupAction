//
//  CJPopupBlankModel.m
//  CJPopupAction
//
//  Created by ciyouzen on 2026/7/25.
//
/*
#import "CJPopupBlankModel.h"

@implementation CJExpandCalculateResultModel

#pragma mark - Init
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Config
#pragma mark 下拉菜单的模型创建方法
/// 情况1：下拉视图宽度占据父视图，且有blankBG时：popupView和blankBG 的 x和width 都是 popupSuperview.origin.x 和  popupSuperview.width;
/// 此时可自己选择是否需要背景（blankBGModel 为 nil ，则代表不需要背景）
///
/// @param popupViewY                   下拉视图的起点和高度，一定要设置
/// @param popupViewHeight        下拉视图的起点和高度，一定要设置
/// @param superViewWidth           下拉视图及blankBG的高度，一定要设置，不然等下取width的时候是0，会导致显示不出来
/// @param blankBGColor             blankBG的宽高已固定，最多允许设置的自定义背景色
///
- (void)downPopupWithY:(CGFloat)popupViewY
                height:(CGFloat)popupViewHeight
        superViewWidth:(CGFloat)superViewWidth
          blankBGColor:(nullable UIColor *)blankBGColor
{
    [self _reset];
    
    _expandToDirection = CJExpandToDirectionDown;
    
    _y = popupViewY;
    _height = popupViewHeight;
    
    _x = 0;
    _width = superViewWidth;
    CJPopupBlankModel *blankBGModel = [CJPopupBlankModel modelWidthColor:blankBGColor];
    _blankBGModel = blankBGModel;
}


/// 情况2：下拉视图宽度占据父视图，且没有的blankBG时：popupView的 x和width 都是 popupSuperview.origin.x 和  popupSuperview.width;
/// 此时可自己选择是否需要背景（blankBGModel 为 nil ，则代表不需要背景）
///
/// @param popupViewY                   下拉视图的起点和高度，一定要设置
/// @param popupViewHeight        下拉视图的起点和高度，一定要设置
///
- (void)downPopupWithY:(CGFloat)popupViewY
                height:(CGFloat)popupViewHeight
{
    [self _reset];
    
    _expandToDirection = CJExpandToDirectionDown;
    
    _y = popupViewY;
    _height = popupViewHeight;
}

/// 情况3：下拉视图宽度不占据父视图，有自定义的起点和大小时，此时没必要有背景，所以不提供 blankBGModel 参数的设置
- (void)downPopupWithTopLeft:(CGPoint)popupViewTopLeft
                        size:(CGSize)popupViewSize
{
    [self _reset];
    
    _expandToDirection = CJExpandToDirectionDown;
    
    _x = popupViewTopLeft.x;
    _y = popupViewTopLeft.y;
    _width = popupViewSize.width;
    _height = popupViewSize.height;
}

// 每次调用上面方法都要调用此方法，避免上面的方法被调用多个时候出现把值设置进去的情况
- (void)_reset {
    _x = 0;
    _y = 0;
    _width = 0;
    _height = 0;
    
    _blankBGModel = nil;
}

@end
*/
