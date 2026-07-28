//
//  TSToastHomeViewController.m
//  CJPopupViewDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "TSToastHomeViewController.h"
#import <Masonry/Masonry.h>

#import "UIView+CJToastAnimation.h"

#import "CQDMSectionDataModel.h"
#import "CQDMModuleModel.h"

@interface TSToastHomeViewController ()

@end

@implementation TSToastHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Toast";
    
    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    
    // Toast
    __weak typeof(self) weakSelf = self;
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"Toast 功能";
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"Toast to Window (nil superView)";
            module.actionBlock = ^{
                UIButton *toastButton = [weakSelf createToastButtonWithTitle:@"Toast to Window"
                                                                    action:@selector(hideToast:)];
                [toastButton cj_toastCenterInView:nil
                                        withSize:CGSizeMake(200, 40)
                                    centerOffset:CGPointMake(0, 0)
                                        animated:YES];
            };
            [sectionDataModel.values addObject:module];
        }
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"Toast to View (自定义偏移)";
            module.actionBlock = ^{
                UIButton *toastButton = [weakSelf createToastButtonWithTitle:@"Toast to View"
                                                                    action:@selector(hideToast:)];
                [toastButton cj_toastCenterInView:weakSelf.view
                                        withSize:CGSizeMake(200, 40)
                                    centerOffset:CGPointMake(0, 100)
                                        animated:YES];
            };
            [sectionDataModel.values addObject:module];
        }
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"Toast with Delay (2秒后隐藏)";
            module.actionBlock = ^{
                UIButton *toastButton = [weakSelf createToastButtonWithTitle:@"Toast with Delay (2s)"
                                                                    action:@selector(hideToast:)];
                [toastButton cj_toastCenterInView:weakSelf.view
                                        withSize:CGSizeMake(200, 40)
                                    centerOffset:CGPointMake(0, 0)
                                        animated:YES];
                
                [toastButton cj_toastHiddenWithAnimated:YES afterDelay:2.0];
            };
            [sectionDataModel.values addObject:module];
        }
        [sectionDataModels addObject:sectionDataModel];
    }
    
    self.sectionDataModels = sectionDataModels;
}

- (UILabel *)createToastLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    return label;
}

- (UIButton *)createToastButtonWithTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blackColor];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)hideToast:(UIButton *)sender {
    [sender cj_toastHiddenWithAnimated:YES afterDelay:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
