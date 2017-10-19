//
//  SettingViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/19.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutMeViewController.h"
#import "LoginViewController.h"
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"设置";
    [self createUI];
}

-(void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 44)];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, screen_width - 20, 44)];
    [btn setTitle:@"退出登录" forState:normal];
    [btn addTarget:self action:@selector(logOutAction) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = ThemeColor;
    [footerView addSubview:btn];
    _tableView.tableFooterView = footerView;
    [self.view addSubview:_tableView];
}

-(void)logOutAction{
    [ZMCHttpTool postWithUrl:WLLogOutURL parameters:@{@"token":[UserInfo getToken]} success:^(id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"1"]){
            //清除所有的本地数据
            NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
            
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:loginVC];
            [self presentViewController:loginNav animated:YES completion:nil];
        }
        else {
        
        }
    } failure:^(NSError *error) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    if (indexPath.section==0){
        cell.textLabel.text = @"关于我们";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AboutMeViewController *aboutMeVC = [[AboutMeViewController alloc]init];
    [self.navigationController pushViewController:aboutMeVC animated:YES];
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
