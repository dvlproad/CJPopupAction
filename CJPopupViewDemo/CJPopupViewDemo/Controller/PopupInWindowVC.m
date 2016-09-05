//
//  PopupInWindowVC.m
//  CJPopupViewDemo
//
//  Created by lichq on 15/11/12.
//  Copyright (c) 2015年 ciyouzen. All rights reserved.
//

#import "PopupInWindowVC.h"
#import "WelcomeViewToPop.h"
#import "UIView+CJPopupInView.h"

@interface PopupInWindowVC ()<WelcomeViewToPopDelegate>

@end

@implementation PopupInWindowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)popupInWindow_center:(id)sender{
    WelcomeViewToPop *popupView = (WelcomeViewToPop *)[[[NSBundle mainBundle] loadNibNamed:@"WelcomeViewToPop" owner:nil options:nil] lastObject];
    popupView.delegate = self;
//    [view popupInWindowLocationType:PopupInWindowLocationCenter animationType:CJPopupViewAnimationCATransform3D];
    [popupView cj_popupInWindowAtPosition:CJWindowPositionCenter animationType:CJAnimationTypeCATransform3D showComplete:^{
        NSLog(@"显示完成");
        
    } tapBlankComplete:^{
        NSLog(@"点击背景完成");
        
    } hideComplete:^{
        NSLog(@"隐藏完成");
        
    }];
}


- (IBAction)popupInWindow_bottom:(id)sender{
    WelcomeViewToPop *popupView = (WelcomeViewToPop *)[[[NSBundle mainBundle] loadNibNamed:@"WelcomeViewToPop" owner:nil options:nil] lastObject];
    popupView.delegate = self;
    [popupView cj_popupInWindowAtPosition:CJWindowPositionBottom animationType:CJAnimationTypeNormal showComplete:^{
        NSLog(@"显示完成");
        
    } tapBlankComplete:^{
        NSLog(@"点击背景完成");
        
    } hideComplete:^{
        NSLog(@"隐藏完成");
        
    }];
}

- (void)dismissPopupView:(UIView *)popupView{
    [popupView cj_hidePopupView];
    
    NSString *message = @"[alert show]应该放在dismiss...之后，否则会造成dismiss...所对应的keywindow不对应";
    [[[UIAlertView alloc]initWithTitle:@"注意" message:message delegate:nil cancelButtonTitle:@"好的，一定注意" otherButtonTitles:nil] show];
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
