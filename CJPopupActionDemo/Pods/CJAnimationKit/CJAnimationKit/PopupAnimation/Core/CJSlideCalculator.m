//
//  CJSlideCalculator.m
//  CJPopupAction
//
//  Created by ciyouzen on 2026/7/25.
//

#import "CJSlideCalculator.h"

@implementation CJSlideCalculator

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

@end
