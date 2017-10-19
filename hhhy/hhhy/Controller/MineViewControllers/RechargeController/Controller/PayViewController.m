//
//  PayViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/19.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "PayViewController.h"
#import "PayOrder_View.h"
#import "WXApi.h"


@interface PayViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) PayOrder_View *payView;

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"充值";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
}

-(void)createUI{
    _payView = [NSBundle.mainBundle loadNibNamed:@"PayOrder_View" owner:self options:nil].lastObject;
    _payView.frame = CGRectMake(0, 74, screen_width, 334);
    _payView.moneyTextField.delegate = self;
    [_payView.finishBtn addTarget:self action:@selector(surePay) forControlEvents:UIControlEventTouchUpInside];
    //微信支付
    [_payView.weixinPayBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    _payView.weixinPayBtn.showsTouchWhenHighlighted = YES;
    //支付宝支付
    [_payView.zhiFuBaoPayBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    _payView.zhiFuBaoPayBtn.showsTouchWhenHighlighted = YES;
    //银行卡支付
    [_payView.bankPayBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    _payView.bankPayBtn.showsTouchWhenHighlighted = YES;
    [self.view addSubview:_payView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_payView.moneyTextField resignFirstResponder];
}

-(void)btnAction: (UIButton *) sender{
    [_payView.moneyTextField resignFirstResponder];

    for (int i=100;i<103;i++){
        UIButton *btn = [self.view viewWithTag:i];
        btn.selected = NO;
        if (sender.tag == 100){
            //银行卡支付
            sender.selected = YES;
        }
        else if (sender.tag == 101){
            //微信支付
            sender.selected = YES;
        }
        else if (sender.tag == 102) {
            //支付宝支付
            sender.selected = YES;
        }
        
    }
    
}

-(void)surePay{
    
    NSInteger tag = 0;
    for (int i=100;i<103;i++){
        UIButton *btn = [self.view viewWithTag:i];
        if (btn.selected) {
            tag = btn.tag;
        }
    }
    if (_payView.moneyTextField.text.floatValue>0){
        
        if (tag == 100){
            //微信支付
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"token"] = [UserInfo getToken];
            parameters[@"money"] = _payView.moneyTextField.text;
            parameters[@"pay_type"] = @"0";
            [ZMCHttpTool postWithUrl:WLRechargeURL parameters:parameters success:^(id responseObject) {
                NSLog(@"===%@",responseObject);
                if([responseObject[@"status"] isEqualToString:@"1"]) {
                    NSDictionary *dic = responseObject[@"data"][@"weixin"];
                    PayReq *request = [[PayReq alloc]init];
                    request.partnerId = dic[@"partnerid"];
                    request.prepayId= dic[@"prepayid"];
                    request.package = dic[@"package"];
                    request.nonceStr= dic[@"noncestr"];
                    request.timeStamp = [dic[@"timestamp"] integerValue];
                    request.sign = dic[@"sign"];
                    [WXApi sendReq:request];
                }
                else {
                    //失败
                }
            } failure:^(NSError *error) {
                
            }];
        }
        else if (tag == 101){
            //支付宝支付
            [self showProgressHud:MBProgressHUDModeText message:@"敬请期待"];
            [self hideProgeressHudAfterDelay:1];
            
        }
        else if (tag == 102) {
            //银行卡支付
            [self showProgressHud:MBProgressHUDModeText message:@"敬请期待"];
            [self hideProgeressHudAfterDelay:1];
        }
        else {
            [self showAlert:@"请选择支付方式"];
        }
    }
    else {
        [self showAlert:@"请输入正确的金额"];
    }
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

{
    if ([string isEqualToString:@"."] && [textField.text isEqualToString:@""]) {
        
        textField.text = @"0.";
        
        return NO;
        
    }
    
    if ([textField.text containsString:@"."] && [string isEqualToString:@"."]){
        return NO;
    }
    
    NSRange myRange = [textField.text rangeOfString:@"."];
    
    if (myRange.length != 0) {
        
        if ([textField.text length]-myRange.location >= 3) {
            
            if ([string isEqualToString:@""]) {
                
                return YES;
                
            }else {
                
                return NO;
                
            }
            
        }else {
            
            return YES;
        }
        
    }else {
        
        return YES;
        
    }
    
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
