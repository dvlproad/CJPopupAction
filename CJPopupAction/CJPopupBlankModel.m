//
//  CJPopupBlankModel.m
//  CJPopupAction
//
//  Created by ciyouzen on 2026/7/25.
//

#import "CJPopupBlankModel.h"

@implementation CJPopupRectModel

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
/// @param blankBGColor             blankBG的宽高已固定，最多允许设置的自定义背景色
///
- (void)downPopupWithY:(CGFloat)popupViewY
                height:(CGFloat)popupViewHeight
          blankBGColor:(nullable UIColor *)blankBGColor
{
    _expandToDirection = CJExpandToDirectionDown;
    
    _y = popupViewY;
    _height = popupViewHeight;
    
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
    _expandToDirection = CJExpandToDirectionDown;
    
    _y = popupViewY;
    _height = popupViewHeight;
}

/// 情况3：下拉视图宽度不占据父视图，有自定义的起点和大小时，此时没必要有背景，所以不提供 blankBGModel 参数的设置
- (void)downPopupWithTopLeft:(CGPoint)popupViewTopLeft
                        size:(CGSize)popupViewSize
{
    _expandToDirection = CJExpandToDirectionDown;
    
    _x = popupViewTopLeft.x;
    _y = popupViewTopLeft.y;
    _width = popupViewSize.width;
    _height = popupViewSize.height;
}


@end










@implementation CJPopupBlankModel

#pragma mark - Init
- (instancetype)init {
    self = [super init];
    if (self) {
        UIColor *blankBGColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.6];
        _color = blankBGColor;
    }
    return self;
}


#pragma mark - Factory
+ (instancetype)defaultModel {
    CJPopupBlankModel *model = [[CJPopupBlankModel alloc] init];
    
    return model;
}

+ (instancetype)modelWidthColor:(nullable UIColor *)color {
    CJPopupBlankModel *model = [[CJPopupBlankModel alloc] init];
    model.color = color;
    
    return model;
}


#pragma mark - Config
/// 遮罩的起点和宽度，未设置则取 popupSuperview.origin.x 和 popupSuperview.width。他们是成对一起配置的，不能单独配置
- (void)setupX:(CGFloat)x width:(CGFloat)width {
    _x = x;
    _width = width;
}

@end
