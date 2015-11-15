//
//  PopupInViewVC.m
//  CJPopupViewDemo
//
//  Created by lichq on 15/11/12.
//  Copyright (c) 2015年 ciyouzen. All rights reserved.
//

#import "PopupInViewVC.h"
#import "CJPopupView.h"

@interface PopupInViewVC ()

@end

@implementation PopupInViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)popup_DropDwonView1:(UIButton *)sender{
    if (popupView1 == nil) {
        UIView *popupView = [[UIView alloc]initWithFrame:CGRectZero];
        popupView.backgroundColor = [UIColor greenColor];
        popupView.tag = 1001;//技巧：为避免每个弹出框的tag一样，这里设置sender.tag，从而弹出框的tag就是sender.tag+固定值了
        
        popupView1 = popupView;
    }
    
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        //button在superView中对应的位置为：
        CGPoint pointBtnConvert = [sender.superview convertPoint:sender.frame.origin toView:self.view];
        //第一个参数必须为所要转化的rect的视图的父视图，这里可以将父视图直接写出，也可用该视图的superview来替代，这样更方便
        NSLog(@"pointBtnConvert = %@", NSStringFromCGPoint(pointBtnConvert));
        CGPoint pointLocation = CGPointMake(pointBtnConvert.x, pointBtnConvert.y + CGRectGetHeight(sender.frame));
        CGSize size_popupView = CGSizeMake(CGRectGetWidth(sender.frame), 100);
        
        [popupView1 popupInView:self.view atLocationPoint:pointLocation withSize:size_popupView complete:^{
            NSLog(@"完成");
        }];
    }else{
        [popupView1 dismissFromSuperView_popupInView];
    }
    
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>下面代码可加可不加>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>//
    [popupView1 setBlockTapBGComplete:^{
        NSLog(@"111...block_TapBGComplete");
        sender.selected = !sender.selected;
        
    } blockPopupViewDismissComplete:^{
        NSLog(@"222...blockPopupViewDismissComplete");
        
    }];
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<//
}


- (IBAction)popup_DropDwonView2:(UIButton *)sender{ //Clip Subviews
    if (popupView2 == nil) {
        UIView *popupView = [[UIView alloc]initWithFrame:CGRectZero];
        popupView.backgroundColor = [UIColor greenColor];
        popupView.tag = 1002;
        
        popupView2 = popupView;
    }
    [self popupDropDownView:popupView2 inView:self.smallView1 underView:sender withHeight:50 complete:nil];
}

- (IBAction)popup_DropDwonView3:(UIButton *)sender{
    if (popupView3 == nil) {
        UIView *popupView = [[UIView alloc]initWithFrame:CGRectZero];
        popupView.backgroundColor = [UIColor greenColor];
        popupView.tag = 1003;
        
        popupView3 = popupView;
    }
    [self popupDropDownView:popupView3 inView:self.view underView:sender withHeight:50 complete:nil];
}

- (void)popupDropDownView:(UIView *)popupView inView:(UIView *)popupSuperview underView:(UIButton *)sender withHeight:(CGFloat)h_popupView complete:(void(^)(void))block{
    CGPoint pointBtnConvert = [sender.superview convertPoint:sender.frame.origin toView:popupSuperview];
    CGPoint pointLocation = CGPointMake(pointBtnConvert.x, pointBtnConvert.y + CGRectGetHeight(sender.frame));
    CGSize size_popupView = CGSizeMake(CGRectGetWidth(sender.frame), h_popupView);
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [popupView popupInView:popupSuperview atLocationPoint:pointLocation withSize:size_popupView complete:block];
    }else{
        [popupView dismissFromSuperView_popupInView];
    }
    
    [popupView setBlockTapBGComplete:^{
        sender.selected = !sender.selected;
        
    } blockPopupViewDismissComplete:^{
        
    }];
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
