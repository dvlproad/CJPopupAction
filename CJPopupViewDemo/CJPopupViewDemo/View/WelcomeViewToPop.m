//
//  WelcomeViewToPop.m
//  CJPopupViewDemo
//
//  Created by lichq on 6/22/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "WelcomeViewToPop.h"

@implementation WelcomeViewToPop

- (IBAction)closePopup:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cjPopupView_Confirm:)]) {
        [self.delegate cjPopupView_Confirm:self];
    }
}

@end
