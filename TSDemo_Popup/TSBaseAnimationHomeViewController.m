//
//  TSBaseAnimationHomeViewController.m
//  CJPopupViewDemo
//
//  Created by ciyouzen on 6/22/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "TSBaseAnimationHomeViewController.h"

#import <CJPopupAction/UIView+CJExpandFrameAnimation.h>
#import <CJPopupAction/UIView+CJSlideTransformAnimation.h>

#import "TSShowAnimateViewController.h"

@interface TSBaseAnimationHomeViewController ()

@end

@implementation TSBaseAnimationHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Base Animation Demo", nil);

    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];

    // Expand Animation
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"Expand Animation";
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"Expand Animation Show";
            module.actionBlock = ^{
                __weak typeof(self) weakSelf = self;
                UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
                testView.backgroundColor = [UIColor redColor];
                [weakSelf.view addSubview:testView];
                
                [UIView cj_expandAnimateView:testView
                                     forShow:YES
                               withShowFrame:CGRectMake(50, 100, 200, 200)
                                   hideFrame:CGRectMake(100, 200, 100, 100)
                                   blankView:nil
                                  completion:^{
                                      NSLog(@"Expand show completed");
                                  }];
            };
            [sectionDataModel.values addObject:module];
        }
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"Expand Animation Hide";
            module.actionBlock = ^{
                __weak typeof(self) weakSelf = self;
                UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, 200, 200)];
                testView.backgroundColor = [UIColor redColor];
                [weakSelf.view addSubview:testView];
                
                [UIView cj_expandAnimateView:testView
                                     forShow:NO
                               withShowFrame:CGRectMake(50, 100, 200, 200)
                                   hideFrame:CGRectMake(100, 200, 100, 100)
                                   blankView:nil
                                  completion:^{
                                      NSLog(@"Expand hide completed");
                                  }];
            };
            [sectionDataModel.values addObject:module];
        }
        [sectionDataModels addObject:sectionDataModel];
    }

    // Slide Animation
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"Slide Animation";
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"Slide Animation Show";
            module.actionBlock = ^{
                __weak typeof(self) weakSelf = self;
                UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
                testView.backgroundColor = [UIColor blueColor];
                [weakSelf.view addSubview:testView];
                
                [UIView cj_slideAnimateView:testView
                                    forShow:YES
                           withShowDirection:CJSlideFromDirectionBottom
                               animateOffset:100
                                  completion:^(BOOL finished) {
                                      NSLog(@"Slide show completed");
                                  }];
            };
            [sectionDataModel.values addObject:module];
        }
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"Slide Animation Hide";
            module.actionBlock = ^{
                __weak typeof(self) weakSelf = self;
                UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
                testView.backgroundColor = [UIColor blueColor];
                [weakSelf.view addSubview:testView];
                
                [UIView cj_slideAnimateView:testView
                                    forShow:NO
                           withShowDirection:CJSlideFromDirectionBottom
                               animateOffset:100
                                  completion:^(BOOL finished) {
                                      NSLog(@"Slide hide completed");
                                  }];
            };
            [sectionDataModel.values addObject:module];
        }
        [sectionDataModels addObject:sectionDataModel];
    }

    // Slide 3D Animation
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"Slide 3D Animation";
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"Slide 3D Animation Show";
            module.actionBlock = ^{
                __weak typeof(self) weakSelf = self;
                UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
                testView.backgroundColor = [UIColor greenColor];
                [weakSelf.view addSubview:testView];
                
                [UIView cj_slide3DAnimateView:testView
                                      forShow:YES
                             withShowDirection:CJSlideFromDirectionBottom
                                 animateOffset:100
                                   rotateAngle:M_PI_4
                                    completion:^(BOOL finished) {
                                        NSLog(@"Slide 3D show completed");
                                    }];
            };
            [sectionDataModel.values addObject:module];
        }
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"Slide 3D Animation Hide";
            module.actionBlock = ^{
                __weak typeof(self) weakSelf = self;
                UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
                testView.backgroundColor = [UIColor greenColor];
                [weakSelf.view addSubview:testView];
                
                [UIView cj_slide3DAnimateView:testView
                                      forShow:NO
                             withShowDirection:CJSlideFromDirectionBottom
                                 animateOffset:100
                                   rotateAngle:M_PI_4
                                    completion:^(BOOL finished) {
                                        NSLog(@"Slide 3D hide completed");
                                    }];
            };
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
            module.title = @"TSShowAnimateViewController ()";
            module.classEntry = [TSShowAnimateViewController class];
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
