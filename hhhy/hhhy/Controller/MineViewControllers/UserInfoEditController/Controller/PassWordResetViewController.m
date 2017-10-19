//
//  PassWordResetViewController.m
//  playboy
//
//  Created by 张梦川 on 16/1/26.
//  Copyright © 2016年 yaoyu. All rights reserved.
//

#import "PassWordResetViewController.h"
#import "NSString+checkTool.h"
#import "LoginViewController.h"
@interface PassWordResetViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

@end

@implementation PassWordResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _oldpwd.delegate = self;
    self.navigationItem.title = @"修改密码";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self giveUpFist];
}
-(void)giveUpFist{
    [self.oldpwd resignFirstResponder];
    [self.newpwd resignFirstResponder];
    [self.aginNewpwd resignFirstResponder];

}


- (IBAction)sumitAction:(id)sender {
    [self giveUpFist];
    if ([self docheck]){
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"token"] = [UserInfo getToken];
        parameters[@"act"] = @"edit_pass";
        parameters[@"old_password"] = self.oldpwd.text;
        parameters[@"password"] = self.newpwd.text;
        parameters[@"confirm_password"] = self.aginNewpwd.text;
        [ZMCHttpTool postWithUrl:WLUserInfoURL parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"status"] isEqualToString:@"1"]) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示消息" message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                [self presentViewController:loginVC animated:YES completion:nil];
            }];
                [alert addAction:sure];

                [self presentViewController:alert animated:YES completion:nil];
                
                
            } else {
                
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

-(BOOL)docheck {
    
        if (![_oldpwd.text isEmpty]){
            if (![_newpwd.text isEmpty]){
                if (![_aginNewpwd.text isEmpty]){
                    if(_newpwd.text.length>5){
                        if ([_aginNewpwd.text isEqualToString:_newpwd.text]){
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
                else{
                    [self showAlert:@"密码不能为空"];
                }

            }
            else{
                [self showAlert:@"密码不能为空"];
            }
        }
        else {
            [self showAlert:@"密码不能为空"];
        }
    return NO;
}


@end
