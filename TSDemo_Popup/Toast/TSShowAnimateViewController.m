//
//  TSShowAnimateViewController.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 2017/2/25.
//  Copyright (c) 2017年 dvlproad. All rights reserved.
//

#import "TSShowAnimateViewController.h"
#import <Masonry/Masonry.h>
#import <CQDemoKit/CQTSButtonFactory.h>
#import <CQDemoKit/CQTSRadioButtonsView.h>

#import <CJPopupAction/UIView+CJSlideConvenience.h>

@interface TSShowAnimateViewController ()

@property (nonatomic, strong) UIView *placeholderView;  // 参照物（不动）
@property (nonatomic, strong) UIButton *toggleButton;   // 动画对象
@property (nonatomic, strong) UISegmentedControl *directionSegment;
@property (nonatomic, strong) CQTSRadioButtonsView *fromTypeRadioButtons;
@property (nonatomic, assign) CJSlideFromDirection selectedDirection;
@property (nonatomic, assign) BOOL isSmallDistance;

@end

@implementation TSShowAnimateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"测试Show的Animation";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.selectedDirection = CJSlideFromDirectionTop;
    self.isSmallDistance = YES;
    
    [self setupUI];
}

- (void)setupUI {
    // 方向选择
    UILabel *directionLabel = [[UILabel alloc] init];
    directionLabel.text = @"方向:";
    [self.view addSubview:directionLabel];
    [directionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).mas_offset(20);
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(30);
    }];
    
    self.directionSegment = [[UISegmentedControl alloc] initWithItems:@[@"上", @"下", @"左", @"右"]];
    self.directionSegment.selectedSegmentIndex = 0;
    [self.directionSegment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.directionSegment];
    [self.directionSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(directionLabel);
        make.left.mas_equalTo(directionLabel.mas_right).mas_offset(10);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
    }];
    
    // 从哪里选择
    UILabel *fromLabel = [[UILabel alloc] init];
    fromLabel.text = @"从:";
    [self.view addSubview:fromLabel];
    [fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(directionLabel.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(30);
    }];
    
    __weak typeof(self) weakSelf = self;
    self.fromTypeRadioButtons = [[CQTSRadioButtonsView alloc] initWithTitles:@[@"小位移：从指定距离滑入", @"Window：从窗口边缘滑入"]
                                                                  alongAxis:MASAxisTypeVertical
                                                               fixedSpacing:5
                                                 didSelectItemAtIndexHandle:^(NSInteger index) {
        weakSelf.isSmallDistance = (index == 0);
        [weakSelf showAction];
    }];
    [self.view addSubview:self.fromTypeRadioButtons];
    [self.fromTypeRadioButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(fromLabel);
        make.left.mas_equalTo(fromLabel.mas_right).mas_offset(10);
        make.right.mas_equalTo(self.view).mas_offset(-10);
        make.height.mas_equalTo(88);
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

- (void)segmentChanged:(UISegmentedControl *)sender {
    if (sender == self.directionSegment) {
        switch (sender.selectedSegmentIndex) {
            case 0: self.selectedDirection = CJSlideFromDirectionTop; break;
            case 1: self.selectedDirection = CJSlideFromDirectionBottom; break;
            case 2: self.selectedDirection = CJSlideFromDirectionLeft; break;
            case 3: self.selectedDirection = CJSlideFromDirectionRight; break;
        }
    }
    
    // 自动执行显示
    [self showAction];
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
