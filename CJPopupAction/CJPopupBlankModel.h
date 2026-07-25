//
//  CJPopupBlankModel.h
//  CJPopupAction
//
//  Created by ciyouzen on 2026/7/25.
//
//  CJPopupBlankModel: 用来根据其是否为空来决定是否添加 可点击的空白背景

#import <UIKit/UIKit.h>
#import "CJPopupCalculator.h"

NS_ASSUME_NONNULL_BEGIN

@class CJPopupBlankModel;
@interface CJPopupRectModel : NSObject {
    
}
@property (nonatomic, assign, readonly) CJExpandToDirection expandToDirection;
/// popupView的起点和宽度，未设置则取 popupSuperview.origin.x 和 popupSuperview.width。他们是成对一起配置的，不能单独配置
@property (nonatomic, assign, readonly) CGFloat x;
@property (nonatomic, assign, readonly) CGFloat y;
@property (nonatomic, assign, readonly) CGFloat width;
@property (nonatomic, assign, readonly) CGFloat height;
@property (nullable, nonatomic, strong, readonly) CJPopupBlankModel *blankBGModel;

#pragma mark - Init
- (instancetype)init NS_DESIGNATED_INITIALIZER;
+ (instancetype)new NS_UNAVAILABLE;

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
          blankBGColor:(nullable UIColor *)blankBGColor;

/// 情况2：下拉视图宽度占据父视图，且没有的blankBG时：popupView的 x和width 都是 popupSuperview.origin.x 和  popupSuperview.width;
/// 此时可自己选择是否需要背景（blankBGModel 为 nil ，则代表不需要背景）
///
/// @param popupViewY                   下拉视图的起点和高度，一定要设置
/// @param popupViewHeight        下拉视图的起点和高度，一定要设置
///
- (void)downPopupWithY:(CGFloat)popupViewY
                height:(CGFloat)popupViewHeight;

/// 情况3：下拉视图宽度不占据父视图，有自定义的起点和大小时，此时没必要有背景，所以不提供 blankBGModel 参数的设置
- (void)downPopupWithTopLeft:(CGPoint)popupViewTopLeft
                        size:(CGSize)popupViewSize;

@end





// 用来根据其是否为空来决定是否添加 可点击的空白背景
@interface CJPopupBlankModel : NSObject {
    
}
/// 空白遮罩的颜色
@property (nullable, nonatomic, strong) UIColor *color;

/// 遮罩的起点和宽度，未设置则取 popupSuperview.origin.x 和 popupSuperview.width。他们是成对一起配置的，不能单独配置
@property (nonatomic, assign, readonly) CGFloat x;
@property (nonatomic, assign, readonly) CGFloat width;

#pragma mark - Init
- (instancetype)init NS_DESIGNATED_INITIALIZER;
+ (instancetype)new NS_UNAVAILABLE;

#pragma mark - Factory
+ (instancetype)defaultModel;
+ (instancetype)modelWidthColor:(nullable UIColor *)color;

#pragma makr - Config
/// 遮罩的起点和宽度，未设置则取 popupSuperview.origin.x 和 popupSuperview.width。他们是成对一起配置的，不能单独配置
- (void)setupX:(CGFloat)x width:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
