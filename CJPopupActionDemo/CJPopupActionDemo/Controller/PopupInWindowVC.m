//
//  PopupInWindowVC.m
//  CJPopupViewDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "PopupInWindowVC.h"
#import <Masonry/Masonry.h>

#import "WelcomeViewToPop.h"
#import "WelcomePopupView.h"

#import "UIView+CJCenterInWindow.h"
#import "UIView+CJBottomInWindow.h"
#import "UIView+CJExpandByPoint.h"

@interface PopupInWindowVC ()<CJPopupViewDelegate>

@end

@implementation PopupInWindowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"PopupInWindow";
    
    UIButton *centerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [centerButton setTitle:@"Popup_Center" forState:UIControlStateNormal];
    centerButton.backgroundColor = [UIColor colorWithRed:0.78 green:0.87 blue:0.63 alpha:1.0];
    [centerButton addTarget:self action:@selector(popupInWindow_center:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:centerButton];
    [centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).mas_offset(184);
        make.left.mas_equalTo(self.view).mas_offset(10);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(30);
    }];
    
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [bottomButton setTitle:@"Popup_Bottom" forState:UIControlStateNormal];
    bottomButton.backgroundColor = [UIColor colorWithRed:0.78 green:0.87 blue:0.63 alpha:1.0];
    [bottomButton addTarget:self action:@selector(popupInWindow_bottom:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomButton];
    [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).mas_offset(246);
        make.left.mas_equalTo(self.view).mas_offset(10);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(30);
    }];
}


- (void)popupInWindow_center:(id)sender{
//    WelcomeViewToPop *popupView = (WelcomeViewToPop *)[[[NSBundle mainBundle] loadNibNamed:@"WelcomeViewToPop" owner:nil options:nil] lastObject];
    WelcomePopupView *popupView = (WelcomePopupView *)[[[NSBundle mainBundle] loadNibNamed:@"WelcomePopupView" owner:nil options:nil] lastObject];
//    popupView.cjExtraOffset = 20;
    
    popupView.popupViewDelegate = self;
    popupView.outestView = self.view;
    
    CGSize popupViewSize = popupView.frame.size;
    //popupViewSize = CGSizeMake(200, 200);
    [popupView cj_showInCenterWindow:CJCenterWindowAnimationType3DSlideToCenter withSize:popupViewSize blankBGColor:nil showComplete:^{
        NSLog(@"显示完成");
        
    } tapBlankComplete:^{
        NSLog(@"点击背景完成");
        [popupView cj_hideFromCenterWindow:YES];
    }];
}


- (void)popupInWindow_bottom:(id)sender{
    WelcomeViewToPop *popupView = (WelcomeViewToPop *)[[[NSBundle mainBundle] loadNibNamed:@"WelcomeViewToPop" owner:nil options:nil] lastObject];
    popupView.popupViewDelegate = self;
    
    CGFloat popupViewHeight = CGRectGetHeight(popupView.frame);
    [popupView cj_showInBottomWindow:CJAnimationTypeNormal withHeight:popupViewHeight edgeInsets:UIEdgeInsetsMake(0, 10, 10, 10) blankBGColor:nil showComplete:^{
        NSLog(@"显示完成");
        
    } tapBlankComplete:^{
        NSLog(@"点击背景完成");
        [popupView cj_hideFromBottomWindow:YES];
    }];
}

#pragma mark - CJPopupViewDelegate
- (void)cjPopupView_Confirm:(UIView *)popupView {
    [popupView cj_hideFromBottomWindow:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
