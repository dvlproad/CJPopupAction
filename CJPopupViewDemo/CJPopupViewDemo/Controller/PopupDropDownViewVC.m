//
//  PopupDropDownViewVC.m
//  CJPopupViewDemo
//
//  Created by lichq on 15/11/12.
//  Copyright (c) 2015年 ciyouzen. All rights reserved.
//

#import "PopupDropDownViewVC.h"
#import "CJPopupView.h"

@interface PopupDropDownViewVC ()

@end

@implementation PopupDropDownViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)popup_DropDwonView1:(UIButton *)sender{
    CGFloat x = CGRectGetMinX(sender.frame);
    CGFloat w = CGRectGetWidth(sender.frame);
    CGFloat h = 100;
    
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(x, 0, w, h)];
    customView.backgroundColor = [UIColor greenColor];
    [sender popupDropDownView:customView inLowestSuperview:self.view complete:^{
        NSLog(@"完成");
    }];
}

- (IBAction)popup_DropDwonView2:(UIButton *)sender{ //Clip Subviews
    CGFloat w = CGRectGetWidth(sender.frame);
    CGFloat h = 50;
    CGFloat x = CGRectGetMinX(sender.frame);
    
    
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(x, 0, w, h)];
    customView.backgroundColor = [UIColor greenColor];
    [sender popupDropDownView:customView inLowestSuperview:self.smallView1 complete:^{
        NSLog(@"完成");
    }];
}

- (IBAction)popup_DropDwonView3:(UIButton *)sender{ //Clip Subviews
    CGFloat w = CGRectGetWidth(sender.frame);
    CGFloat h = 50;
    CGPoint origin = [sender.superview convertPoint:sender.frame.origin toView:self.view];
    CGFloat x = origin.x;
    
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(x, 0, w, h)];
    customView.backgroundColor = [UIColor greenColor];
    [sender popupDropDownView:customView inLowestSuperview:self.view complete:^{
        NSLog(@"完成");
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
