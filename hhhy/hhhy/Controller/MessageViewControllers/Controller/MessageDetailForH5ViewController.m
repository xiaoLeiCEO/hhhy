//
//  MessageDetailForH5ViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/17.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "MessageDetailForH5ViewController.h"
#import "RewardView.h"

@interface MessageDetailForH5ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong) UIButton *rewardBtn;
@property (nonatomic,strong) RewardView *rewardView;
@property (nonatomic,strong) UIView *grayBackgroundView;

@end

@implementation MessageDetailForH5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"详情";
    NSURL* url = [NSURL URLWithString:_content];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [_webView loadRequest:request];//加载
//    [self createUI];
}

-(UIView *)grayBackgroundView{
    if (!_grayBackgroundView){
        _grayBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
        _grayBackgroundView.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.5];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [_grayBackgroundView addGestureRecognizer:tapGes];
    }
    return _grayBackgroundView;
}

-(void)createUI{
    self.rewardBtn = [[UIButton alloc]initWithFrame:CGRectMake(screen_width-80, screen_height-80, 50, 50)];
    self.rewardBtn.layer.masksToBounds = YES;
    self.rewardBtn.layer.cornerRadius = 25;
    self.rewardBtn.backgroundColor = [UIColor orangeColor];
    [self.rewardBtn setTitle:@"打赏" forState:normal];
    [self.rewardBtn addTarget:self action:@selector(rewardBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.rewardBtn.tintColor = [UIColor whiteColor];
    [self.view addSubview:self.rewardBtn];
}

-(void)tapAction{
    [self.grayBackgroundView removeFromSuperview];
    [self.rewardView removeFromSuperview];
}


//打赏按钮点击事件
-(void)rewardBtnAction{
    [self.view addSubview:self.grayBackgroundView];
    self.rewardView = [[NSBundle mainBundle] loadNibNamed:@"RewardView" owner:self options:nil].lastObject;
    self.rewardView.frame = CGRectMake(0, 0, 170, 200);
    self.rewardView.layer.masksToBounds = YES;
    self.rewardView.layer.cornerRadius = 10;
    self.rewardView.center = self.view.center;
    [self.rewardView.rewardBtn addTarget:self action:@selector(rewardBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.rewardView.closeBtn addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rewardView];
}

//打赏
-(void)rewardBtnClick{
    
    [self.grayBackgroundView removeFromSuperview];
    [self.rewardView removeFromSuperview];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"act"] = @"a_reward";
    parameters[@"type"] = @"2";
    parameters[@"money"] = @"2";
    parameters[@"bds_id"] = self.userId;
    parameters[@"id_type"] = @"3";
    parameters[@"token"] = [UserInfo getToken];
    
    [ZMCHttpTool postWithUrl:WLRewardURL parameters:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]){
            [self showProgressHud:MBProgressHUDModeText message:responseObject[@"msg"]];
            [self hideProgeressHudAfterDelay:2];
        }
        else {
            [self showProgressHud:MBProgressHUDModeText message:responseObject[@"msg"]];
            [self hideProgeressHudAfterDelay:2];
        }
    } failure:^(NSError *error) {
        
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
