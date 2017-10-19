//
//  RootViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/1.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "RootViewController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "AttentionViewController.h"
#import "MineViewController.h"
#import "WLTabBar.h"
#import "AnimationViewController.h"
#import "WLNavigationController.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    WLTabBar *tabBar = [[WLTabBar alloc]init];
    //TabBar是ZSTabBar类中私有属性,通过KVC赋值  关键
    [self setValue:tabBar forKey:@"tabBar"];
    //自定义TabBar的block
    tabBar.composeButtonBlock = ^(NSArray *composeButton){
        //从数组取出Button
        UIButton *compoeButton = composeButton[0];
        //按钮的点击事件
        [self composeButtonClick:compoeButton];
    };
    
    [self createController];
}




-(void)createController{
    
    HomeViewController *homeVC = [[HomeViewController alloc]init];

    UINavigationController *homeNav = [[WLNavigationController alloc]initWithRootViewController:homeVC];
    homeNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"活动" image:[UIImage imageNamed:@"sy"] selectedImage:[[UIImage imageNamed:@"sydq"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    MessageViewController *messageVC = [[MessageViewController alloc]init];
    
    UINavigationController *messageNav = [[WLNavigationController alloc]initWithRootViewController:messageVC];
    messageNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"资讯" image:[UIImage imageNamed:@"zxun"] selectedImage:[[UIImage imageNamed:@"zxundq"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    AttentionViewController *attentionVC = [[AttentionViewController alloc]init];
    UINavigationController *attentionNav = [[WLNavigationController alloc]initWithRootViewController:attentionVC];
    attentionNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"赛事" image:[UIImage imageNamed:@"gz"] selectedImage:[[UIImage imageNamed:@"gzdq"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    MineViewController *mineVC = [[MineViewController alloc]init];
    UINavigationController *mineNav = [[WLNavigationController alloc]initWithRootViewController:mineVC];
    mineNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:[UIImage imageNamed:@"grzx"] selectedImage:[[UIImage imageNamed:@"grzxdq"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    self.viewControllers = @[homeNav,messageNav,attentionNav,mineNav];
}

#pragma mark -- 中间撰写按钮的点击事件
-(void)composeButtonClick:(UIButton *)send{
//    在这里就可以实现撰写按钮的方法
    AnimationViewController *animationVC = [[AnimationViewController alloc]init];
    UINavigationController *animationNav = [[UINavigationController alloc]initWithRootViewController:animationVC];
    animationVC.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    animationNav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    animationNav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:animationNav animated:NO completion:nil];
}


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
