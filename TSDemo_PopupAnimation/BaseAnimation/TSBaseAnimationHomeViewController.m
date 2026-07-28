//
//  TSBaseAnimationHomeViewController.m
//  CJPopupViewDemo
//
//  Created by ciyouzen on 6/22/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "TSBaseAnimationHomeViewController.h"

#import <CJPopupAnimation/UIView+CJExpandFrameAnimation.h>
#import <CJPopupAnimation/UIView+CJSlideTransformAnimation.h>

#import "TSSlideAnimateViewController.h"
#import "TSExpandAnimateViewController.h"

@interface TSBaseAnimationHomeViewController ()

@end

@implementation TSBaseAnimationHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Base Animation Demo", nil);

    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];

    // Slide Animation
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"Slide Animation";
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"TSSlideAnimateViewController";
            module.classEntry = [TSSlideAnimateViewController class];
            [sectionDataModel.values addObject:module];
        }
        [sectionDataModels addObject:sectionDataModel];
    }

    // Expand Animation
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"Expand Animation";
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"TSExpandAnimateViewController";
            module.classEntry = [TSExpandAnimateViewController class];
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
