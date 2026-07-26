//
//  UIWindow+RootSetting.m
//  CJPopupActionDemo
//
//  Created by ciyouzen on 2026/7/27.
//  Copyright © 2026年 dvlproad. All rights reserved.
//

#import "UIWindow+RootSetting.h"
#import <TSDemo_Popup_Swift/TSDemo_Popup_Swift-Swift.h>

@implementation UIWindow (RootSetting)

- (void)settingRoot {
    [self setBackgroundColor:[UIColor whiteColor]];
    UIViewController *rootViewController = [[TSPopupMainViewController alloc] init];
    self.rootViewController = rootViewController;
    [self makeKeyAndVisible];
}

@end
