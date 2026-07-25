//
//  CJPopupCalculator.m
//  CJPopupAction
//
//  Created by ciyouzen on 2026/7/25.
//

#import "CJPopupCalculator.h"

@implementation CJPopupCalculator

+ (CGAffineTransform)slideHideTransformWithDirection:(CJSlideFromDirection)direction
                                             offset:(CGFloat)offset
{
    switch (direction) {
        case CJSlideFromDirectionTop:
            return CGAffineTransformMakeTranslation(0, -offset);
        case CJSlideFromDirectionBottom:
            return CGAffineTransformMakeTranslation(0, offset);
        case CJSlideFromDirectionLeft:
            return CGAffineTransformMakeTranslation(-offset, 0);
        case CJSlideFromDirectionRight:
            return CGAffineTransformMakeTranslation(offset, 0);
    }
    return CGAffineTransformIdentity;
}

+ (CJPopupFramePair)expandToDownFromLeftTop:(CGPoint)leftTop size:(CGSize)size
{
    CGRect showFrame = CGRectMake(leftTop.x, leftTop.y, size.width, size.height);
    CGRect hideFrame = CGRectMake(leftTop.x, leftTop.y, size.width, 0);
    return (CJPopupFramePair){ showFrame, hideFrame };
}

+ (CJPopupFramePair)expandToUpFromLeftBottom:(CGPoint)leftBottom size:(CGSize)size
{
    CGRect showFrame = CGRectMake(leftBottom.x, leftBottom.y - size.height, size.width, size.height);
    CGRect hideFrame = CGRectMake(leftBottom.x, leftBottom.y, size.width, 0);
    return (CJPopupFramePair){ showFrame, hideFrame };
}
/*
+ (CJPopupFramePair)expandToRightFromLeftTop:(CGPoint)leftTop size:(CGSize)size
{
    CGRect showFrame = CGRectMake(leftTop.x, leftTop.y, size.width, size.height);
    CGRect hideFrame = CGRectMake(leftTop.x, leftTop.y, 0, size.height);
    return (CJPopupFramePair){ showFrame, hideFrame };
}

+ (CJPopupFramePair)expandToLeftFromRightTop:(CGPoint)rightTop size:(CGSize)size
{
    CGRect showFrame = CGRectMake(rightTop.x - size.width, rightTop.y, size.width, size.height);
    CGRect hideFrame = CGRectMake(rightTop.x, rightTop.y, 0, size.height);
    return (CJPopupFramePair){ showFrame, hideFrame };
}
*/
+ (CJPopupFramePair)expandToCenterFromCenter:(CGPoint)center size:(CGSize)size
{
    CGRect showFrame = CGRectMake(center.x - size.width / 2.0,
                                  center.y - size.height / 2.0,
                                  size.width,
                                  size.height);
    CGRect hideFrame = CGRectMake(center.x, center.y, 0, 0);
    return (CJPopupFramePair){ showFrame, hideFrame };
}

@end
