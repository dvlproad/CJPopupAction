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
    // Do any additional setup after loading the view, typically from a nib.
    self.title = NSLocalizedString(@"PopupViewDemo", nil);
}

- (IBAction)goPopupInWindowVC:(id)sender{
    PopupInWindowVC *vc = [[PopupInWindowVC alloc]initWithNibName:@"PopupInWindowVC" bundle:nil];
    vc.title = [sender titleForState:UIControlStateNormal];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)goPopupInViewVC:(id)sender{
    PopupInViewVC *vc = [[PopupInViewVC alloc]initWithNibName:@"PopupInViewVC" bundle:nil];
    vc.title = [sender titleForState:UIControlStateNormal];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)goShowExtendViewVC:(id)sender{
    ShowExtendViewVC *vc = [[ShowExtendViewVC alloc]initWithNibName:@"ShowExtendViewVC" bundle:nil];
    vc.title = [sender titleForState:UIControlStateNormal];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)goShowDropDownViewController:(id)sender{
    ShowDropDownViewController *vc = [[ShowDropDownViewController alloc]initWithNibName:@"ShowDropDownViewController" bundle:nil];
    vc.title = [sender titleForState:UIControlStateNormal];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
