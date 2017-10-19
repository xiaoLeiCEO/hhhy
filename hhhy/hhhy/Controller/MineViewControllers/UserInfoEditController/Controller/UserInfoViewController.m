//
//  UserInfoViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/18.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoEditViewController.h"
#import "PassWordResetViewController.h"

@interface UserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UserInfoEditViewControllerDelegate>{
    NSArray *dataSource;
}

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dataSource = @[@"昵称",@"性别",@"修改手机号",@"修改密码"];
    
    self.navigationItem.title = @"个人信息";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
}

-(void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = dataSource[indexPath.row];
    switch (indexPath.row) {
        case 0:
            cell.detailTextLabel.text = _mineModel.nick_name;
            break;
        case 1:
            if ([_mineModel.sex isEqualToString:@"0"]){
                cell.detailTextLabel.text = @"女";
            }
            else if ([_mineModel.sex isEqualToString:@"1"]){
                cell.detailTextLabel.text = @"男";
            }
            else {
                cell.detailTextLabel.text = @"保密";
            }
            break;
        case 2:
            cell.detailTextLabel.text = _mineModel.mobile_phone;
            break;
            
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    if (indexPath.row == 3){
        //修改密码页面
        PassWordResetViewController *passWordResetVC = [[PassWordResetViewController alloc]init];
        [self.navigationController pushViewController:passWordResetVC animated:YES];
    }
    else {
//        修改用户信息页面
        UserInfoEditViewController *userInfoEditVC = [[UserInfoEditViewController alloc]init];
        userInfoEditVC.delegate = self;
        userInfoEditVC.navigationItem.title = cell.textLabel.text;
        userInfoEditVC.defaultText = cell.detailTextLabel.text;
        userInfoEditVC.index = indexPath.row;
        [self.navigationController pushViewController:userInfoEditVC animated:YES];
    }
}

-(void)sendMessage:(NSString *)message{
    switch ([_tableView indexPathForSelectedRow].row) {
        case 0:
        {
            _mineModel.nick_name = message;
        }
            break;
        case 1:
            if ([message isEqualToString:@"女"]){
                _mineModel.sex = @"0";
            }
            else if ([message isEqualToString:@"男"]){
               _mineModel.sex = @"1";
            }
            else {
                _mineModel.sex = @"2";
            }
            break;
        case 2:
            _mineModel.mobile_phone = message;
            break;
            
        default:
            break;
    }
    [_tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
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
