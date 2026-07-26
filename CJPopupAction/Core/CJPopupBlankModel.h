//
//  CJPopupBlankModel.h
//  CJPopupAction
//
//  Created by ciyouzen on 2026/7/25.
//
//  CJPopupBlankModel: 用来根据其是否为空来决定是否添加 可点击的空白背景
//  且目前blankBG只支持默认popupSuperview满宽(下拉菜单，不必支持非popupSuperview满宽的情况，视觉体验不好)
//
//  CJPopupRectModel: 弹出视图的位置及是否要有空白区域背景的模型（此类是为了用来用一个模型来控制多个方向的，目前其实没什么用，因为只有固定下拉菜单）

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 用来根据其是否为空来决定是否添加 可点击的空白背景
// 且目前blankBG只支持默认popupSuperview满宽(下拉菜单，不必支持非popupSuperview满宽的情况，视觉体验不好)
@interface CJPopupBlankModel : NSObject {
    
}
/// 空白遮罩的颜色
@property (nullable, nonatomic, strong) UIColor *color;
/*
/// 遮罩的起点和宽度，未设置则取 popupSuperview.origin.x 和 popupSuperview.width。他们是成对一起配置的，不能单独配置
/// 目前不开放此接口：(下拉菜单，不必支持非popupSuperview满宽的情况，视觉体验不好)
@property (nonatomic, assign, readonly) CGFloat x;
@property (nonatomic, assign, readonly) CGFloat width;
*/
#pragma mark - Init
- (instancetype)init NS_DESIGNATED_INITIALIZER;
+ (instancetype)new NS_UNAVAILABLE;

#pragma mark - Factory
+ (instancetype)defaultModel;
+ (instancetype)modelWidthColor:(nullable UIColor *)color;

#pragma makr - Config
/// 遮罩的起点和宽度，未设置则取 popupSuperview.origin.x 和 popupSuperview.width。他们是成对一起配置的，不能单独配置。
/// 目前不开放此接口：(下拉菜单，不必支持非popupSuperview满宽的情况，视觉体验不好)
//- (void)setupX:(CGFloat)x width:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
