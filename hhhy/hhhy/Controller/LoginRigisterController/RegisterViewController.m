//
//  RegisterViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/5.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "RegisterViewController.h"
#import "NSString+checkTool.h"
#import <sys/utsname.h>
@interface RegisterViewController ()<UITextFieldDelegate>

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_isRegister){
        self.navigationItem.title = @"注册";
        [_registerBtn setTitle:@"注册" forState:normal];
    }
    else {
        self.navigationItem.title = @"忘记密码";
        [_registerBtn setTitle:@"马上找回" forState:normal];
    }
    _phoneNumTf.delegate = self;
    _passwordTf.delegate = self;
    _rePasswordTf.delegate = self;
    _codeTf.delegate = self;

}

-(BOOL)docheck {
    if (![_phoneNumTf.text isEmpty]){
        if (![_passwordTf.text isEmpty]){
            if (![_rePasswordTf.text isEmpty]){
                    if ([_phoneNumTf.text isUsableMobile]){
                        if(_passwordTf.text.length>5){
                            if ([_passwordTf.text isEqualToString:_rePasswordTf.text]){
                                return YES;
                            }
                            else{
                                [self showAlert:@"两次输入密码不一致"];
                            }
                        }
                        else {
                            [self showAlert:@"密码不能小于6位"];
                        }
                    }
                    else {
                        [self showAlert:@"请输入正确的手机号"];
                    }
            }
            else{
                [self showAlert:@"密码不能为空"];
            }
        }
        else {
            [self showAlert:@"密码不能为空"];
        }
    }
    else{
        [self showAlert:@"手机号不能为空"];
    }
    return NO;
}

//获取验证码按钮的点击事件
- (IBAction)getCodeBtnAction:(UIButton *)sender {
    if ([self docheck]){
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
        parameters[@"mobile"] = _phoneNumTf.text;
        parameters[@"send_type"] = @"1";
        [ZMCHttpTool postWithUrl:WLSendMessageURL parameters:parameters success:^(id responseObject) {
            NSLog(@"%@", responseObject);
            if ([responseObject[@"status"] isEqualToString:@"1"]){
                NSLog(@"%@",@"短信发送成功");
                [self showProgressHud:MBProgressHUDModeText message:@"短信发送成功"];
                [self hideProgeressHudAfterDelay:2];
            }
            else {
                [self showProgressHud:MBProgressHUDModeText message:responseObject[@"msg"]];
                [self hideProgeressHudAfterDelay:2];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}
//注册按钮的点击事件
- (IBAction)registerBtnAction:(UIButton *)sender {
    if ([self docheck]){
        if (![_codeTf.text isEmpty]){
            if (_isRegister){
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
                parameters[@"mobile"] = _phoneNumTf.text;
                parameters[@"verify"] = _codeTf.text;
                parameters[@"password"] = _passwordTf.text;
                parameters[@"confirm_password"] = _rePasswordTf.text;
                parameters[@"type_origin"] = @"2";
                parameters[@"phone_model"] = [self iphoneType];
                [self showProgressHud:MBProgressHUDModeIndeterminate message:@"正在加载..."];
                [ZMCHttpTool postWithUrl:WLRegisterURL parameters:parameters success:^(id responseObject) {
                    NSLog(@"%@", responseObject);
                    if ([responseObject[@"status"] isEqualToString:@"1"]){
                        [self hideProgressHud];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else {
                        [self hideProgressHud];
                        [self showAlert:responseObject[@"msg"]];
                    }
                } failure:^(NSError *error) {
                    
                }];
            }
            else {
                //忘记密码
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
                parameters[@"mobile"] = _phoneNumTf.text;
                parameters[@"verify"] = _codeTf.text;
                parameters[@"password"] = _passwordTf.text;
                parameters[@"confirm_password"] = _rePasswordTf.text;
                parameters[@"act"] = @"reset_pass";
                [self showProgressHud:MBProgressHUDModeIndeterminate message:@"正在加载..."];
                [ZMCHttpTool postWithUrl:WLUserInfoURL parameters:parameters success:^(id responseObject) {
                    NSLog(@"%@", responseObject);
                    if ([responseObject[@"status"] isEqualToString:@"1"]){
                        [self hideProgressHud];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else {
                        [self hideProgressHud];
                        [self showAlert:responseObject[@"msg"]];
                    }
                } failure:^(NSError *error) {
                    
                }];
            }
        }
        else {
            [self showAlert:@"验证码不能为空"];
        }
    }
}


- (NSString *)iphoneType {
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])  return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])  return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])  return @"iPad 2";

    if ([platform isEqualToString:@"iPad2,3"])  return @"iPad 2";

    if ([platform isEqualToString:@"iPad2,4"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])  return @"iPad Mini 1G";

    if ([platform isEqualToString:@"iPad3,1"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";

    if ([platform isEqualToString:@"iPad4,1"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])   return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    
    return platform;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
