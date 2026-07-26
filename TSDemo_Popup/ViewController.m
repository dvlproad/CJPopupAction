//
//  ViewController.m
//  CJPopupViewDemo
//
//  Created by ciyouzen on 6/22/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "ViewController.h"

#import "PopupInWindowVC.h"
#import "PopupInViewVC.h"
#import "ShowExtendViewVC.h"
#import "ShowDropDownViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"CJPopupAction Demo", nil);

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
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"ShowExtendView (展开弹出)";
            module.classEntry = [ShowExtendViewVC class];
            module.isCreateByXib = YES;
            module.xibBundle = [NSBundle bundleForClass:[self class]];
            [sectionDataModel.values addObject:module];
        }
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"ShowDropDown (下拉菜单)";
            module.classEntry = [ShowDropDownViewController class];
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
