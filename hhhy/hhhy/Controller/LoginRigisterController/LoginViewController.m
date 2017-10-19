//
//  LoginViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/5.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "NSString+checkTool.h"
#import "RootViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barTintColor = ThemeColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"登录";
    _accountTf.delegate = self;
    _passwordTf.delegate = self;
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat keyboardHeight = height - (screen_height - _acountPasswordView.frame.origin.y - _acountPasswordView.frame.size.height);

    if (keyboardHeight>0){
        _topConstraint.constant = screen_height - height - 86;
        [UIView animateWithDuration:keyboardDuration animations:^{
            [_acountPasswordView updateConstraints];
        }];
    }
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    _topConstraint.constant = 185;
    NSDictionary *userInfo = [aNotification userInfo];
    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    [UIView animateWithDuration:keyboardDuration animations:^{
        [_acountPasswordView updateConstraints];

    }];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_accountTf resignFirstResponder];
    [_passwordTf resignFirstResponder];
}


//忘记密码的点击事件
- (IBAction)forgetPasswordBtnAction:(UIButton *)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    registerVC.isRegister = NO;
    [self.navigationController pushViewController:registerVC animated:YES];
}
//登录按钮的点击事件
- (IBAction)loginBtnAction:(UIButton *)sender {
    if (![_accountTf.text isEmpty]){
        if (![_passwordTf.text isEmpty]){
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
            parameters[@"user_name"] = _accountTf.text;
            parameters[@"password"] = _passwordTf.text;
            [self showProgressHud:MBProgressHUDModeText message:@"正在登陆..."];
            [ZMCHttpTool postWithUrl:WLLoginURL parameters:parameters success:^(id responseObject) {
                NSLog(@"%@", responseObject);
                if ([responseObject[@"status"] isEqualToString:@"1"]){
                    [self hideProgressHud];
                    [UserInfo setIsLogin:YES];
                    [UserInfo setToken:responseObject[@"data"][@"token"]];
                    [self presentViewController:[[RootViewController alloc]init] animated:YES completion:nil];
                }
                else{
                    [self hideProgressHud];
                    [self showAlert:responseObject[@"msg"]];
                }
            } failure:^(NSError *error) {
                
            }];
        }
        else {
            [self showAlert:@"密码不能为空"];
        }
    }
    else{
        [self showAlert:@"用户名不能为空"];
    }
}
//注册按钮的点击事件
- (IBAction)registerBtnAction:(UIButton *)sender {
    
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    registerVC.isRegister = YES;
    [self.navigationController pushViewController:registerVC animated:YES];}

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
