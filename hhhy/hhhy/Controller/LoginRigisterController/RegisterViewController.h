//
//  RegisterViewController.h
//  hhhy
//
//  Created by 王长磊 on 2017/7/5.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "BaseViewController.h"

@interface RegisterViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;
@property (weak, nonatomic) IBOutlet UITextField *rePasswordTf;
@property (weak, nonatomic) IBOutlet UITextField *codeTf;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (nonatomic,assign) BOOL isRegister;

@end
