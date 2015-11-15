//
//  PopupInViewVC.h
//  CJPopupViewDemo
//
//  Created by lichq on 15/11/12.
//  Copyright (c) 2015年 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupInViewVC : UIViewController{
    UIView *popupView1;
    UIView *popupView2;
    UIView *popupView3;
}
@property(nonatomic, weak) IBOutlet UIView *smallView1;
@property(nonatomic, weak) IBOutlet UIView *smallView2;

@end
