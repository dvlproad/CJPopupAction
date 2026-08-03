//
//  UIView+CJInterceptorChain.m
//  CJAnimationKit
//
//  Created by ciyouzen on 2026/7/31.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJInterceptorChain.h"

@implementation UIView (CJInterceptorChain)

+ (void)cj_runInterceptorChain:(NSArray *)interceptors
              withDefaultBlock:(void(^)(void))defaultBlock {
    if (interceptors.count == 0) {
        !defaultBlock ?: defaultBlock();
        return;
    }
    
    __block NSInteger index = 0;
    __block void(^chain)(void) = nil;
    
    void(^nextBlock)(void) = ^{
        if (index >= interceptors.count) {
            // 链结束，执行默认动画，并断开 chain 引用，避免形成循环引用
            chain = nil;
            !defaultBlock ?: defaultBlock();
        } else {
            void(^interceptor)(void(^)(void)) = (void(^)(void(^)(void)))interceptors[index];
            index++;
            interceptor(chain);
        }
    };
    
    chain = nextBlock;
    nextBlock();
}

@end
