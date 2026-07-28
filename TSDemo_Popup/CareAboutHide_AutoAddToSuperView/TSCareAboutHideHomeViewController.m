//
//  TSCareAboutHideHomeViewController.m
//  CJPopupViewDemo
//
//  Created by ciyouzen on 6/22/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "TSCareAboutHideHomeViewController.h"

#import "PopupInViewVC.h"

@interface TSCareAboutHideHomeViewController ()

@end

@implementation TSCareAboutHideHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"CareAboutHide Demo", nil);

    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];

    // Popup
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"Popup 功能";
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"PopupInView (弹出到指定View)";
            module.classEntry = [PopupInViewVC class];
            module.isCreateByXib = YES;
            module.xibBundle = [NSBundle bundleForClass:[self class]];
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
