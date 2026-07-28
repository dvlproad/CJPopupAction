//
//  TSWindowAnimationHomeViewController.m
//  CJPopupViewDemo
//
//  Created by ciyouzen on 6/22/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "TSWindowAnimationHomeViewController.h"

#import "PopupInWindowVC.h"

@interface TSWindowAnimationHomeViewController ()

@end

@implementation TSWindowAnimationHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Window Animation Demo", nil);

    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];

    // Popup
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"Popup 功能";
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"PopupInWindow (居中/底部弹出到Window)";
            module.classEntry = [PopupInWindowVC class];
            module.isCreateByXib = NO;
            [sectionDataModel.values addObject:module];
        }
        [sectionDataModels addObject:sectionDataModel];
    }

    self.sectionDataModels = sectionDataModels;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
