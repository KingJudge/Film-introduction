//
//  TabViewController.m
//  Movie
//
//  Created by 袁文轶 on 16/1/18.
//  Copyright © 2016年 wx. All rights reserved.
//

#import "TabViewController.h"

@interface TabViewController ()

@end

@implementation TabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //在main.story中找到名为first的页面，将该页面设置为_firstVC全局对象
    _firstVC = [storyboard instantiateViewControllerWithIdentifier:@"First"];
    //将_firstVC设置为_firstNC导航控制器的跟视图
    _firstNC = [[UINavigationController alloc]initWithRootViewController:_firstVC];
    //为_firstNC导航控制器设置tab bar item，将该选项卡栏项目的标题设置为first,图片设置为名为first的图片，下表设为0
    _firstNC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"First"] tag:0];
    
    UIStoryboard *storyboard2 = [UIStoryboard storyboardWithName:@"Second" bundle:[NSBundle mainBundle]];
    _SecondVC = [storyboard2 instantiateViewControllerWithIdentifier:@"Second"];
    _SecondNC = [[UINavigationController alloc]initWithRootViewController:_SecondVC];
    _SecondNC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"分类" image:[UIImage imageNamed:@"Second"] tag:1];
    //设置选项卡栏控制器的选项卡栏项目（@［］数组中的每个item都会对应一个选项卡栏项目）
    self.viewControllers = @[_firstNC,_SecondNC];
}
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
//{
//    if (viewController == _firstNC) {
//        NSLog(@"切换到第一个页面");
//    }else if (viewController == _SecondNC){
//        NSLog(@"切换到第二个页面");
//    }
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
