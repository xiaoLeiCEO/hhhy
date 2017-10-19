//
//  AnimationViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/6.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "AnimationViewController.h"
#import "AnimtaionView.h"
#import "DynamicViewController.h"
#import "LogViewController.h"
#import "PhotosFileViewController.h"
@interface AnimationViewController ()
@property (strong, nonatomic)  UIButton *centerBtn;

@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    //设置backBarButtonItem即可
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationBar.barTintColor = ThemeColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.5 animations:^{
        for (int i=0;i<6;i++){
            int line = i % 3;
            int row = i / 3;
            AnimtaionView *animationView = [self.view viewWithTag:i+100];
            CGFloat animationViewBtnWidth = animationView.btn.frame.size.width;
            animationView.alpha = 0;
            animationView.frame = CGRectMake(line*((screen_width-animationViewBtnWidth*3)/3+animationViewBtnWidth)+(screen_width-animationViewBtnWidth*3)/6, row*(screen_width/3)+200+10+120+71, animationViewBtnWidth, animationViewBtnWidth +21);
        }
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self createUI];
    
}

-(void)createUI{
    NSArray *arr = @[@"相册",@"动态",@"日志"];
    NSArray *array = @[@"xiangce",@"dongtai",@"rizhi"];
    for (int i=0;i<3;i++){
        int line = i % 3;
        int row = i / 3;
        AnimtaionView *animationView = [[AnimtaionView alloc]init];
        animationView.btn.frame = CGRectMake(0, 0, 50, 50);
        animationView.label.frame = CGRectMake(0, 50, 50, 21);
        CGFloat animationViewBtnWidth = animationView.btn.frame.size.width;
        animationView.frame = CGRectMake(line*((screen_width-animationViewBtnWidth*3)/3+animationViewBtnWidth)+(screen_width-animationViewBtnWidth*3)/6, row*(screen_width/3)+200+10+120+71, animationViewBtnWidth, animationViewBtnWidth +21);
        animationView.tag = i + 100;
        [animationView.btn setBackgroundImage:[UIImage imageNamed:array[i]] forState:normal];
        animationView.btn.tag = i + 200;
        animationView.label.text = arr[i];
        [animationView.btn addTarget:self action:@selector(animationViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:animationView];
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            animationView.frame = CGRectMake(line*((screen_width-animationViewBtnWidth*3)/3+animationViewBtnWidth)+(screen_width-animationViewBtnWidth*3)/6, row*(screen_width/3)+200+10+120, animationViewBtnWidth, animationViewBtnWidth +21);
        } completion:nil];

    }
    
    _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_centerBtn setImage:[UIImage imageNamed:@"centerBar"] forState:normal];
    [_centerBtn addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _centerBtn.frame = CGRectMake((screen_width-63)/2, screen_height-8-63, 63, 63);
    [self.view addSubview:_centerBtn];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    for (int i=0;i<6;i++){
        AnimtaionView *animationView = [self.view viewWithTag:i+100];
        [animationView removeFromSuperview];
    }
    [_centerBtn removeFromSuperview];
}

-(void)animationViewBtnAction:(UIButton *)sender{
    if (sender.tag - 200 == 0){
        //相册
        PhotosFileViewController *photosFileVC = [[PhotosFileViewController alloc]init];
        photosFileVC.isEvents = NO;
        [self.navigationController pushViewController:photosFileVC animated:YES];
    }
    else if (sender.tag - 200 == 1){
//        动态
        DynamicViewController *dynamicVC = [[DynamicViewController alloc]init];
        [self.navigationController pushViewController:dynamicVC animated:YES];
    }
    else if (sender.tag - 200 == 2){
//    日志
        LogViewController *logVC = [[LogViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
    }
    else if (sender.tag - 200 == 3){
//    讲课

    }
    else if (sender.tag - 200 == 4){
//    拍摄
    }
    else if (sender.tag - 200 == 5){
//        更多功能
    }
}

- (void)centerBtnClick:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        for (int i=0;i<6;i++){
            int line = i % 3;
            int row = i / 3;
            AnimtaionView *animationView = [self.view viewWithTag:i+100];
            CGFloat animationViewBtnWidth = animationView.btn.frame.size.width;
            animationView.alpha = 0;
            animationView.frame = CGRectMake(line*((screen_width-animationViewBtnWidth*3)/3+animationViewBtnWidth)+(screen_width-animationViewBtnWidth*3)/6, row*(screen_width/3)+200+10+120+71, animationViewBtnWidth, animationViewBtnWidth +21);
        }
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
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
