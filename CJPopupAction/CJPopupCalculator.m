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

+ (CJPopupFramePair)expandToDownFromTopLeft:(CGPoint)topLeft size:(CGSize)size
{
    CGRect showFrame = CGRectMake(topLeft.x, topLeft.y, size.width, size.height);
    CGRect hideFrame = CGRectMake(topLeft.x, topLeft.y, size.width, 0);
    return (CJPopupFramePair){ showFrame, hideFrame };
}

+ (CJPopupFramePair)expandToUpFromBottomLeft:(CGPoint)bottomLeft size:(CGSize)size
{
    CGRect showFrame = CGRectMake(bottomLeft.x, bottomLeft.y - size.height, size.width, size.height);
    CGRect hideFrame = CGRectMake(bottomLeft.x, bottomLeft.y, size.width, 0);
    return (CJPopupFramePair){ showFrame, hideFrame };
}

+ (CJPopupFramePair)expandToRightFromTopLeft:(CGPoint)topLeft size:(CGSize)size
{
    CGRect showFrame = CGRectMake(topLeft.x, topLeft.y, size.width, size.height);
    CGRect hideFrame = CGRectMake(topLeft.x, topLeft.y, 0, size.height);
    return (CJPopupFramePair){ showFrame, hideFrame };
}

+ (CJPopupFramePair)expandToLeftFromTopRight:(CGPoint)topRight size:(CGSize)size
{
    CGRect showFrame = CGRectMake(topRight.x - size.width, topRight.y, size.width, size.height);
    CGRect hideFrame = CGRectMake(topRight.x, topRight.y, 0, size.height);
    return (CJPopupFramePair){ showFrame, hideFrame };
}

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
