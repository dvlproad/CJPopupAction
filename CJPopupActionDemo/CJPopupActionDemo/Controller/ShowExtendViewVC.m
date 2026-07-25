//
//  ShowExtendViewVC.m
//  CJPopupViewDemo
//
//  Created by ciyouzen on 15/11/16.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "ShowExtendViewVC.h"
#import <Masonry/Masonry.h>
#import <CQDemoKit/CQTSButtonFactory.h>
#import "UIView+CJShowExtendView.h"

@interface ShowExtendViewVC () {
    
}
@property (nonatomic, strong) UIColor *popupBgColor;

@end

@implementation ShowExtendViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.popupBgColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.6];
    
    __weak typeof(self) weakSelf = self;
    UIButton *popupBGColorButton = [CQTSButtonFactory submitButtonWithSubmitTitle:@"当前无blankBG" editTitle:@"当前有blankBG" showEditTitle:YES clickSubmitTitleHandle:^(UIButton * _Nonnull button) {
        button.selected = !button.selected;
        weakSelf.popupBgColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.6];
    } clickEditTitleHandle:^(UIButton * _Nonnull button) {
        button.selected = !button.selected;
        weakSelf.popupBgColor = nil;
    }];
    [self.view addSubview:popupBGColorButton];
    [popupBGColorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).mas_offset(400);
        make.centerX.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).mas_equalTo(20);
        make.height.mas_equalTo(40);
    }];
}


- (IBAction)showPopupInView1:(UIButton *)sender{
    UIView *popupView = [[UIView alloc]initWithFrame:CGRectZero];
    popupView.backgroundColor = [UIColor greenColor];
    popupView.tag = 1001;//技巧：为避免每个弹出框的tag一样，这里设置sender.tag，从而弹出框的tag就是sender.tag+固定值了
    
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        UIView *popupSuperview = self.view;
        CGFloat h_popupView = 50;
        
        CGPoint pointBtnConvert = [sender.superview convertPoint:sender.frame.origin toView:popupSuperview];
        CGPoint pointLocation = CGPointMake(pointBtnConvert.x, pointBtnConvert.y + CGRectGetHeight(sender.frame));
        CGSize size_popupView = CGSizeMake(CGRectGetWidth(sender.frame), h_popupView);
    
        [sender cj_showExtendView:popupView inView:popupSuperview atLocation:pointLocation withSize:size_popupView blankBGColor:self.popupBgColor showComplete:^{
            NSLog(@"显示完成");
            
        } tapBlankComplete:^{
            NSLog(@"点击背景完成");
            sender.selected = !sender.selected;
            
            [popupView cj_hidePopupView];
        }];
        
    }else{
        [sender cj_hideExtendViewAnimated:YES];
    }

}


- (IBAction)showPopupInView2:(UIButton *)sender{ //Clip Subviews
    UIView *popupView = [[UIView alloc]initWithFrame:CGRectZero];
    popupView.backgroundColor = [UIColor greenColor];
    popupView.tag = 1002;
    
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        UIView *popupSuperview = self.smallView1;
        CGFloat h_popupView = 50;
        
        CGPoint pointBtnConvert = [sender.superview convertPoint:sender.frame.origin toView:popupSuperview];
        CGPoint pointLocation = CGPointMake(pointBtnConvert.x, pointBtnConvert.y + CGRectGetHeight(sender.frame));
        CGSize size_popupView = CGSizeMake(CGRectGetWidth(sender.frame), h_popupView);
        
        [sender cj_showExtendView:popupView inView:popupSuperview atLocation:pointLocation withSize:size_popupView blankBGColor:self.popupBgColor showComplete:^{
            NSLog(@"显示完成");
            
        } tapBlankComplete:^{
            NSLog(@"点击背景完成");
            sender.selected = !sender.selected;
            
            [popupView cj_hidePopupView];
        }];
        
    }else{
        [sender cj_hideExtendViewAnimated:YES];
    }
}

- (IBAction)showPopupInView3:(UIButton *)sender{
    UIView *popupView = [[UIView alloc]initWithFrame:CGRectZero];
    popupView.backgroundColor = [UIColor greenColor];
    popupView.tag = 1003;
    
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        UIView *popupSuperview = self.view;
        CGFloat h_popupView = 50;
        
        CGPoint pointBtnConvert = [sender.superview convertPoint:sender.frame.origin toView:popupSuperview];
        CGPoint pointLocation = CGPointMake(pointBtnConvert.x, pointBtnConvert.y + CGRectGetHeight(sender.frame));
        CGSize size_popupView = CGSizeMake(CGRectGetWidth(sender.frame), h_popupView);
        
        [sender cj_showExtendView:popupView inView:popupSuperview atLocation:pointLocation withSize:size_popupView blankBGColor:self.popupBgColor showComplete:^{
            NSLog(@"显示完成");
            
        } tapBlankComplete:^{
            NSLog(@"点击背景完成");
            sender.selected = !sender.selected;
            
            [sender cj_hideExtendViewAnimated:YES];
        }];
        
    }else{
        [sender cj_hideExtendViewAnimated:YES];
    }
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
