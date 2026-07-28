//
//  CJExpandCalculator.m
//  CJPopupAction
//
//  Created by ciyouzen on 2026/7/25.
//

#import "CJExpandCalculator.h"

@implementation CJExpandCalculator

#pragma mark - 计算 showFrame
+ (CGRect)showFrameFromLeftTop:(CGPoint)leftTop size:(CGSize)size {
    return CGRectMake(leftTop.x, leftTop.y, size.width, size.height);
}

+ (CGRect)showFrameFromLeftBottom:(CGPoint)leftBottom size:(CGSize)size {
    return CGRectMake(leftBottom.x, leftBottom.y - size.height, size.width, size.height);
}

+ (CGRect)showFrameFromCenter:(CGPoint)center size:(CGSize)size {
    return CGRectMake(center.x - size.width / 2.0,
                      center.y - size.height / 2.0,
                      size.width,
                      size.height);
}

#pragma mark - 计算 hideFrame
+ (CGRect)hideFrameFromShowFrame:(CGRect)showFrame
                       direction:(CJExpandToDirection)direction {
    CGFloat x = CGRectGetMinX(showFrame);
    CGFloat y = CGRectGetMinY(showFrame);
    CGFloat width = CGRectGetWidth(showFrame);
    CGFloat height = CGRectGetHeight(showFrame);
    
    switch (direction) {
        case CJExpandToDirectionCenter:
            // 向四周展开：hideFrame = 中心点（size=0）
            return CGRectMake(x + width / 2.0, y + height / 2.0, 0, 0);
        case CJExpandToDirectionDown:
            // 向下展开：hideFrame = 左上角（height=0）
            return CGRectMake(x, y, width, 0);
        case CJExpandToDirectionUp:
            // 向上展开：hideFrame = 左下角（height=0）
            return CGRectMake(x, y + height, width, 0);
    }
}

@end
