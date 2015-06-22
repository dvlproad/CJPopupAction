//
//  ViewController.m
//  CJPopupViewDemo
//
//  Created by lichq on 6/22/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "ViewController.h"
#import "UIView+CJPopupView.h"
#import "WelcomeViewToPop.h"

@interface ViewController ()<CJPopupViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)popupView_bottom:(id)sender{
    WelcomeViewToPop *view = (WelcomeViewToPop *)[[[NSBundle mainBundle] loadNibNamed:@"WelcomeViewToPop" owner:nil options:nil] lastObject];
    view.delegate = self;
    [view showInLocationType:CJPopupViewLocationBottom animationType:CJPopupViewAnimationCATransform3D];
}

- (IBAction)popupView_center:(id)sender{
    WelcomeViewToPop *view = (WelcomeViewToPop *)[[[NSBundle mainBundle] loadNibNamed:@"WelcomeViewToPop" owner:nil options:nil] lastObject];
    view.delegate = self;
    [view showInLocationType:CJPopupViewLocationCenter animationType:CJPopupViewAnimationCATransform3D];
}


- (void)dismissPopupView:(UIView *)view{
    [view dismissWithAnimationType:CJPopupViewAnimationCATransform3D];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
