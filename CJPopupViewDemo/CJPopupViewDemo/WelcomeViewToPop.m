//
//  WelcomeViewToPop.m
//  CJPopupViewDemo
//
//  Created by lichq on 6/22/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "WelcomeViewToPop.h"

@implementation WelcomeViewToPop
@synthesize delegate;

- (IBAction)closePopup:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissPopupView:)]) {
        [self.delegate dismissPopupView:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
