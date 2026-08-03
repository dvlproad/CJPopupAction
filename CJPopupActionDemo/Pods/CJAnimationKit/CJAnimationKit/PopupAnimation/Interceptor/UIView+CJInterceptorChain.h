//
//  UIView+CJInterceptorChain.h
//  CJAnimationKit
//
//  Created by ciyouzen on 2026/7/31.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//
//  动画拦截器的公共机制：通用链执行器，供各拦截器类型文件复用。
//  各拦截器类型的存储(全局/实例)由各自的文件独立管理，互不干扰，
//  新增/删除某种拦截器类型时，无需改动本文件

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 通用链执行器
@interface UIView (CJInterceptorChain)

/// 依次执行拦截器链，链结束后执行 defaultBlock
/// @param interceptors 拦截器数组，每个元素是 void(^)(void(^next)(void)) 类型的 block
+ (void)cj_runInterceptorChain:(NSArray *)interceptors
              withDefaultBlock:(void(^)(void))defaultBlock;

@end

NS_ASSUME_NONNULL_END
