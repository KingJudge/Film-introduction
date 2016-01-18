//
//  TabViewController.h
//  Movie
//
//  Created by 袁文轶 on 16/1/18.
//  Copyright © 2016年 wx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"
#import "SecondViewController.h"

@interface TabViewController : UITabBarController <UITabBarControllerDelegate>

@property (strong,nonatomic) UINavigationController *firstNC;
@property (strong,nonatomic) FirstViewController *firstVC;

@property (strong,nonatomic) UINavigationController *SecondNC;
@property (strong,nonatomic) SecondViewController *SecondVC;

@end
