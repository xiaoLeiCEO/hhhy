//
//  WLNavigationController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/18.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "WLNavigationController.h"
#import "ViewMacro.h"
@interface WLNavigationController ()

@end

@implementation WLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(instancetype)initWithRootViewController:(UIViewController *)rootViewController{
        self = [super initWithRootViewController:rootViewController];
    if (self){
        self.navigationBar.barTintColor = ThemeColor;
        self.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    }
    return self;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) { // 如果不是添加栈底的控制器才需要隐藏tabbar
        // 不能直接让所有的控制器都隐藏tabBar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
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
