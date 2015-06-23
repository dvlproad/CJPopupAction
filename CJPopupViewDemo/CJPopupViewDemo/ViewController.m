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
    [view dismissPopupViewWithAnimationType:CJPopupViewAnimationCATransform3D];
    
    NSString *message = @"[alert show]应该放在dismiss...之后，否则会造成dismiss...所对应的keywindow不对应";
    [[[UIAlertView alloc]initWithTitle:@"注意" message:message delegate:nil cancelButtonTitle:@"好的，一定注意" otherButtonTitles:nil] show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
