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

- (IBAction)popup_DropDwonView:(UIButton *)sender{
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.view.frame)-20, 100)];
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
