//
//  WelcomeViewToPop.h
//  CJPopupViewDemo
//
//  Created by lichq on 6/22/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WelcomeViewToPopDelegate<NSObject>
@optional
- (void)dismissPopupView:(UIView*)view;
@end



@interface WelcomeViewToPop : UIView

@property (assign, nonatomic) id <WelcomeViewToPopDelegate>delegate;

@end
