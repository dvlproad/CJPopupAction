//
//  ShowDropDownViewController.m
//  CJPopupViewDemo
//
//  Created by 李超前 on 16/8/31.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "ShowDropDownViewController.h"
#import <Masonry/Masonry.h>
#import <CQDemoKit/CQTSRadioButtonsView.h>
#import <CJPopupAction/UIView+CJShowExtendView.h>
#import <CJPopupAction/UIView+CJBlankView.h>

@interface ShowDropDownViewController () {
    
}
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIView *popupBlankView;
@property (nonatomic, strong) CQTSRadioButtonsView *directionRadioButtons;
@property (nonatomic, assign) NSInteger selectedDirectionIndex;

@end

@implementation ShowDropDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.popupBlankView = [UIView cj_defaultBlankView];
    self.selectedDirectionIndex = 0;
    
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button.backgroundColor = [UIColor colorWithRed:0.412 green:0.757 blue:0.953 alpha:1.0];
    [self.button setTitle:@"Button" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(-100);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(281);
        make.height.mas_equalTo(30);
    }];
    
    // 方向选择（单选按钮，支持重复点击同一选项）
    __weak typeof(self) weakSelf = self;
    self.directionRadioButtons = [[CQTSRadioButtonsView alloc] initWithTitles:@[@"上方", @"下方", @"居中"]
                                                                  alongAxis:MASAxisTypeHorizontal
                                                               fixedSpacing:10
                                                 didSelectItemAtIndexHandle:^(NSInteger index) {
        weakSelf.selectedDirectionIndex = index;
        // 如果已展开，切换方向时自动刷新
        if (weakSelf.button.selected) {
            [weakSelf.button cj_hideExtendViewAnimated:NO];
            weakSelf.button.selected = NO;
            [weakSelf buttonClick:weakSelf.button];
        }
    }];
    [self.view addSubview:self.directionRadioButtons];
    [self.directionRadioButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.button.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(44);
    }];
}

- (IBAction)buttonClick:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        CGFloat width = CGRectGetWidth(button.frame);
        CGFloat height = 200;
        
        UIView *popupView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, height)];
        popupView.clipsToBounds = YES;
        popupView.backgroundColor = [UIColor greenColor];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(20, 50, width-40, 44)];
        [btn setTitle:@"生成随机数，并设置" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor redColor]];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [popupView addSubview:btn];
        
        
        CJExpandForViewPosition position;
        switch (self.selectedDirectionIndex) {
            case 0: position = CJExpandForViewPositionAbove; break;
            case 1: position = CJExpandForViewPositionBelow; break;
            case 2: position = CJExpandForViewPositionCenter; break;
            default: position = CJExpandForViewPositionAbove; break;
        }
        
        [button cj_showExtendView:popupView inView:self.view locationAccordingView:button relativePosition:position blankView:self.popupBlankView showComplete:^{
            NSLog(@"显示完成");
        } tapBlankComplete:^() {
            NSLog(@"点击背景完成");
            button.selected = !button.selected;
            
            [button cj_hideExtendViewAnimated:YES];
        }];
        
    } else {
        [button cj_hideExtendViewAnimated:YES];
    }
}

- (IBAction)btnAction:(id)sender {
    NSString *text = [NSString stringWithFormat:@"%d", rand()%10];
    NSLog(@"text = %@", text);
    [self.button setTitle:text forState:UIControlStateNormal];
    
    self.button.selected = !self.button.selected;
    [self.button cj_hideExtendViewAnimated:YES];
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
