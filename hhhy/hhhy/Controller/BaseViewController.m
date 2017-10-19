//
//  BaseViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/1.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<MBProgressHUDDelegate>
@property (nonatomic,strong) MBProgressHUD* progressHud;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(MBProgressHUD *)progressHud{
    if(!_progressHud){
        _progressHud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:_progressHud];
        _progressHud.delegate = self;
    }
    return _progressHud;
}

-(void)showProgressHud:(MBProgressHUDMode )mode message:(NSString *)msg{
    self.progressHud.mode = mode;
    self.progressHud.label.text = msg;
    [self.progressHud showAnimated:YES];

}

-(void)hideProgressHud{
    [self.progressHud hideAnimated:YES];
}

-(void)hideProgeressHudAfterDelay:(NSTimeInterval) delay{
    [self.progressHud hideAnimated:YES afterDelay:delay];
}

-(void)hudWasHidden:(MBProgressHUD *)hud{
    [self.progressHud removeFromSuperview];
    self.progressHud = nil;
}
-(void)showAlert:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示消息" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];
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
