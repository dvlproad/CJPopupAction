//
//  CJPopupBlankModel.m
//  CJPopupAction
//
//  Created by ciyouzen on 2026/7/25.
//

#import "CJPopupBlankModel.h"

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

/*
#pragma mark - Config
/// 遮罩的起点和宽度，未设置则取 popupSuperview.origin.x 和 popupSuperview.width。他们是成对一起配置的，不能单独配置。
/// 目前不开放此接口：(下拉菜单，不必支持非popupSuperview满宽的情况，视觉体验不好)
- (void)setupX:(CGFloat)x width:(CGFloat)width {
    _x = x;
    _width = width;
}
*/
@end
