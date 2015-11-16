//
//  ShowPopupInViewVC.m
//  CJPopupViewDemo
//
//  Created by lichq on 15/11/16.
//  Copyright (c) 2015年 ciyouzen. All rights reserved.
//

#import "ShowPopupInViewVC.h"
#import "CJPopupView.h"

@interface ShowPopupInViewVC ()

@end

@implementation ShowPopupInViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    
        [sender showPopupView:popupView InView:popupSuperview atLocationPoint:pointLocation withSize:size_popupView showComplete:^{
            NSLog(@"显示完成");
            
        } tapBGComplete:^{
            NSLog(@"点击背景完成");
            sender.selected = !sender.selected;
            
        } hideComplete:^{
            NSLog(@"隐藏完成");
            
        }];
        
    }else{
        [sender showPopupInView_dismissPopupViewAnimated:YES];
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
        
        [sender showPopupView:popupView InView:popupSuperview atLocationPoint:pointLocation withSize:size_popupView showComplete:^{
            NSLog(@"显示完成");
            
        } tapBGComplete:^{
            NSLog(@"点击背景完成");
            sender.selected = !sender.selected;
            
        } hideComplete:^{
            NSLog(@"隐藏完成");
            
        }];
        
    }else{
        [sender showPopupInView_dismissPopupViewAnimated:YES];
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
        
        [sender showPopupView:popupView InView:popupSuperview atLocationPoint:pointLocation withSize:size_popupView showComplete:^{
            NSLog(@"显示完成");
            
        } tapBGComplete:^{
            NSLog(@"点击背景完成");
            sender.selected = !sender.selected;
            
        } hideComplete:^{
            NSLog(@"隐藏完成");
            
        }];
        
    }else{
        [sender showPopupInView_dismissPopupViewAnimated:YES];
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
