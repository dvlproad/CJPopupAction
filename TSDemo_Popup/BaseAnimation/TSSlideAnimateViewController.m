//
//  TSSlideAnimateViewController.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 2017/2/25.
//  Copyright (c) 2017年 dvlproad. All rights reserved.
//

#import "TSSlideAnimateViewController.h"
#import <Masonry/Masonry.h>
#import <CQDemoKit/CQTSButtonFactory.h>
#import <CQDemoKit/CQTSRadioButtonsView.h>

#import <CJPopupAction/UIView+CJSlideConvenience.h>

@interface TSSlideAnimateViewController ()

@property (nonatomic, strong) UIView *placeholderView;  // 参照物（不动）
@property (nonatomic, strong) UIButton *toggleButton;   // 动画对象
@property (nonatomic, strong) CQTSRadioButtonsView *directionRadioButtons;
@property (nonatomic, strong) CQTSRadioButtonsView *fromTypeRadioButtons;
@property (nonatomic, assign) CJSlideFromDirection selectedDirection;
@property (nonatomic, assign) BOOL isSmallDistance;

@end

@implementation TSSlideAnimateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"测试Slide的Animation";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.selectedDirection = CJSlideFromDirectionTop;
    self.isSmallDistance = YES;
    
    [self setupUI];
}

- (void)setupUI {
    // 方向选择（单选按钮，支持重复点击同一选项）
    __weak typeof(self) weakSelf = self;
    self.directionRadioButtons = [[CQTSRadioButtonsView alloc] initWithTitles:@[@"上", @"下", @"左", @"右"]
                                                                  alongAxis:MASAxisTypeHorizontal
                                                               fixedSpacing:10
                                                 didSelectItemAtIndexHandle:^(NSInteger index) {
        switch (index) {
            case 0: weakSelf.selectedDirection = CJSlideFromDirectionTop; break;
            case 1: weakSelf.selectedDirection = CJSlideFromDirectionBottom; break;
            case 2: weakSelf.selectedDirection = CJSlideFromDirectionLeft; break;
            case 3: weakSelf.selectedDirection = CJSlideFromDirectionRight; break;
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
    
    // 从哪里选择（单选按钮）
    self.fromTypeRadioButtons = [[CQTSRadioButtonsView alloc] initWithTitles:@[@"小位移：从指定距离滑入", @"Window：从窗口边缘滑入"]
                                                                  alongAxis:MASAxisTypeVertical
                                                               fixedSpacing:5
                                                 didSelectItemAtIndexHandle:^(NSInteger index) {
        weakSelf.isSmallDistance = (index == 0);
        [weakSelf showAction];
    }];
    [self.view addSubview:self.fromTypeRadioButtons];
    [self.fromTypeRadioButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.directionRadioButtons.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.right.mas_equalTo(self.view).mas_offset(-20);
        make.height.mas_equalTo(88); // 2个按钮 × 44
    }];
    
    // 参照物说明
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"灰色区域为参照物，实际使用时不会有";
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textColor = [UIColor grayColor];
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.fromTypeRadioButtons.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(self.view).mas_offset(20);
    }];
    
    // 参照物（不动的占位视图）
    self.placeholderView = [[UIView alloc] init];
    self.placeholderView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    self.placeholderView.layer.borderColor = [UIColor grayColor].CGColor;
    self.placeholderView.layer.borderWidth = 1;
    [self.view addSubview:self.placeholderView];
    [self.placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);
    }];
    
    // 按钮（叠加在参照物上方，动画时移开）
    self.toggleButton = [CQTSButtonFactory submitButtonWithSubmitTitle:@"显示" editTitle:@"隐藏" showEditTitle:NO clickSubmitTitleHandle:^(UIButton *button) {
        button.selected = !button.selected;
        [weakSelf showAction];
    } clickEditTitleHandle:^(UIButton *button) {
        button.selected = !button.selected;
        [weakSelf hideAction];
    }];
    [self.view addSubview:self.toggleButton];
    [self.toggleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.placeholderView);
    }];
}

- (void)showAction {
    if (self.isSmallDistance) {
        // 小位移
        [self.toggleButton cq_slideFromOffset:40 direction:self.selectedDirection];
    } else {
        // 从Window
        [self.toggleButton cq_slideFromWindowDirection:self.selectedDirection];
    }
}

- (void)hideAction {
    [self.toggleButton cq_slideSmallForHideWithAnimate:YES];
}

@end
