//
//  TSExpandAnimateViewController.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 2017/2/25.
//  Copyright (c) 2017年 dvlproad. All rights reserved.
//

#import "TSExpandAnimateViewController.h"
#import <Masonry/Masonry.h>
#import <CQDemoKit/CQTSButtonFactory.h>
#import <CQDemoKit/CQTSRadioButtonsView.h>

#import <CJPopupAnimation/UIView+CJExpandFrameAnimationBind.h>
#import <CJPopupAnimation/CJExpandCalculator.h>

@interface TSExpandAnimateViewController ()

@property (nonatomic, strong) UIView *placeholderView;  // 参照物（不动）
@property (nonatomic, strong) UIButton *toggleButton;   // 动画对象
@property (nonatomic, strong) CQTSRadioButtonsView *directionRadioButtons;
@property (nonatomic, assign) CJExpandToDirection selectedDirection;

@end

@implementation TSExpandAnimateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"测试Expand的Animation";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.selectedDirection = CJExpandToDirectionCenter;
    
    [self setupUI];
}

- (void)setupUI {
    // 方向选择（单选按钮，支持重复点击同一选项）
    __weak typeof(self) weakSelf = self;
    self.directionRadioButtons = [[CQTSRadioButtonsView alloc] initWithTitles:@[@"居中", @"下", @"上"]
                                                                  alongAxis:MASAxisTypeHorizontal
                                                               fixedSpacing:10
                                                 didSelectItemAtIndexHandle:^(NSInteger index) {
        switch (index) {
            case 0: weakSelf.selectedDirection = CJExpandToDirectionCenter; break;
            case 1: weakSelf.selectedDirection = CJExpandToDirectionDown; break;
            case 2: weakSelf.selectedDirection = CJExpandToDirectionUp; break;
        }
        [weakSelf showAction];
    }];
    [self.view addSubview:self.directionRadioButtons];
    [self.directionRadioButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).mas_offset(20);
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.right.mas_equalTo(self.view).mas_offset(-20);
        make.height.mas_equalTo(44);
    }];
    
    // 参照物说明
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"灰色区域为参照物，实际使用时不会有";
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textColor = [UIColor grayColor];
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.directionRadioButtons.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(self.view).mas_offset(20);
    }];
    
    // 参照物（不动的占位视图）— 居中，200x200
    self.placeholderView = [[UIView alloc] init];
    self.placeholderView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    self.placeholderView.layer.borderColor = [UIColor grayColor].CGColor;
    self.placeholderView.layer.borderWidth = 1;
    [self.view addSubview:self.placeholderView];
    [self.placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(200);
    }];
    
    // 动画视图（叠加在参照物上方）
    self.toggleButton = [[UIButton alloc] init];
    self.toggleButton.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1.0];
    [self.toggleButton setTitle:@"动画视图" forState:UIControlStateNormal];
    [self.toggleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.toggleButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.toggleButton.userInteractionEnabled = NO; // 不需要点击，由上方单选按钮控制
    [self.view addSubview:self.toggleButton];
    [self.toggleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.placeholderView);
    }];
}

- (void)showAction {
    // showFrame = view 当前的 frame（即动画最终目标）
    // direction 决定 hideFrame 在 showFrame 的哪条边上（由 CJExpandCalculator 自动计算）
    CGRect popupShowFrame = self.toggleButton.frame;
    
    [UIView cj_showExpandAnimateBindView:self.toggleButton
                          withShowFrame:popupShowFrame
                              direction:self.selectedDirection
                              blankView:nil
                             completion:nil];
}

@end
