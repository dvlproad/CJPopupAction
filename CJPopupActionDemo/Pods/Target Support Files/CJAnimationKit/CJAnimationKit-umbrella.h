#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "UIView+CJExpandFrameAnimation.h"
#import "UIView+CJSlideTransformAnimation.h"
#import "UIView+CJExpandFrameAnimationBind.h"
#import "UIView+CJSlideTransformAnimationBind.h"
#import "UIView+CJSlideConvenience.h"
#import "CJExpandCalculateResultModel.h"
#import "CJExpandCalculator.h"
#import "CJSlideCalculator.h"
#import "UIView+CJExpandInterceptor.h"
#import "UIView+CJInterceptorChain.h"
#import "UIView+CJSlide3DInterceptor.h"
#import "UIView+CJSlideInterceptor.h"

FOUNDATION_EXPORT double CJAnimationKitVersionNumber;
FOUNDATION_EXPORT const unsigned char CJAnimationKitVersionString[];

