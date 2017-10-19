//
//  OrderViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/20.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "OrderViewController.h"
#import "CommitOrderFooterView.h"
#import "NSString+checkTool.h"
#import "TicketTableViewCell.h"
#import "PayOrderView.h"
#import "OrderListViewController.h"
#import "UpLoadVideoViewController.h"
@interface OrderViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *dataSource;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSString *phoneNum;
@property (nonatomic,copy) NSString *orderSn; //定单号

@property (nonatomic,strong) CommitOrderFooterView *footerView;
@property (nonatomic,strong) PayOrderView *payOrderView;
@property (nonatomic,strong) UIView *grayBackground;

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"订单";
    self.view.backgroundColor = [UIColor whiteColor];
    dataSource = [[NSMutableArray alloc]init];
    [self createUI];
    [self loadData];
}

-(void)createUI{
    _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height-50) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"TicketTableViewCell" bundle:nil] forCellReuseIdentifier:@"ticketCell"];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    _footerView = [[NSBundle mainBundle]loadNibNamed:@"CommitOrderFooterView" owner:self options:nil].lastObject;
    _footerView.frame = CGRectMake(0, screen_height - 50, screen_width, 50);
    [_footerView.commitOrderBtn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_footerView];
}

-(UIView *)grayBackground{
    if (!_grayBackground) {
        _grayBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
        _grayBackground.backgroundColor = [UIColor blackColor];
        _grayBackground.alpha = 0.3;
    }
    return _grayBackground;
}

-(void)loadData{
    _phoneNum = [UserInfo getPhoneNum];
    if (_phoneNum){
        [_tableView reloadData];
    }
    else {
        //获取手机号
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
        parameters[@"act"] = @"user_info";
        parameters[@"token"] = [UserInfo getToken];
        [ZMCHttpTool postWithUrl:WLUserInfoURL parameters:parameters success:^(id responseObject) {
            NSLog(@"%@", responseObject);
            if ([responseObject[@"status"] isEqualToString:@"1"]){
                [UserInfo setUserInfo:responseObject[@"data"][@"info"]];
                [UserInfo setPhoneNum:responseObject[@"data"][@"info"][@"mobile_phone"]];
                _phoneNum = [UserInfo getPhoneNum];
                [_tableView reloadData];
            }
            else {
                
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"act"] = @"activity";
    parameters[@"hd_id"] = _eventsId;
    if (_isPlayer){
        //选手
    parameters[@"type"] = @"1";
    }
    else {
        //围观
        parameters[@"type"] = @"2";
    }
    parameters[@"token"] = [UserInfo getToken];
    [ZMCHttpTool postWithUrl:WLTicketListURL parameters:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]){
            for (NSDictionary *dic in responseObject[@"data"][@"list"]){
                OrderModel *orderModel = [[OrderModel alloc]init];
                [orderModel setValuesForKeysWithDictionary:dic];
                [dataSource addObject:orderModel];
            }
            [_tableView reloadData];
        }
        else {
        
        }
    } failure:^(NSError *error) {
        
    }];
}

//提交订单
-(void)commitAction{
    OrderModel *orderModel = dataSource[[_tableView indexPathForSelectedRow].row];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"token"] = [UserInfo getToken];
    parameters[@"act"] = @"add_order";
    parameters[@"hd_id"] = _eventsId;
    parameters[@"type"] = orderModel.type;
    parameters[@"id_value"] = orderModel.ticketId;
    parameters[@"price"] = orderModel.price;
    
    if (_isSaiShi){
    parameters[@"is_mark"] = @"1";
    }
    else {
        parameters[@"is_mark"] = @"0";
    }
    
    [ZMCHttpTool postWithUrl:WLOrderURL parameters:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]){
            
            _orderSn = responseObject[@"data"][@"order_sn"];
            [self.view addSubview:self.grayBackground];

            _payOrderView = [[NSBundle mainBundle]loadNibNamed:@"PayOrderView" owner:self options:nil].lastObject;
            _payOrderView.frame = CGRectMake(0, screen_height, screen_width, 350);
            _payOrderView.priceLabel.text = [NSString stringWithFormat:@"￥%@",orderModel.price];
            
            if ([UserInfo getUserInfo][@"balance"]){
            _payOrderView.balanceLabel.text = [NSString stringWithFormat:@"￥%@",[UserInfo getUserInfo][@"balance"]];
            }
            
            [_payOrderView.payMoneyBtn addTarget:self action:@selector(payMoneyBtnAction) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:_payOrderView];
            [UIView animateWithDuration:0.5 animations:^{
                _payOrderView.center = CGPointMake(screen_width / 2, screen_height - 175);
            }];
        }
        else {
            [self showProgressHud:MBProgressHUDModeText message:responseObject[@"msg"]];
            [self hideProgeressHudAfterDelay:1];
        }
    } failure:^(NSError *error) {
        
    }];
}

//确认支付
-(void)payMoneyBtnAction{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"token"] = [UserInfo getToken];
    parameters[@"act"] = @"pay_order";
    parameters[@"order_sn"] = _orderSn;
    [ZMCHttpTool postWithUrl:WLOrderURL parameters:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]){
            [UIView animateWithDuration:0.5 animations:^{
                _payOrderView.center = CGPointMake(screen_width / 2, screen_height + 175);
                
            } completion:^(BOOL finished) {
                [_grayBackground removeFromSuperview];
                [_payOrderView removeFromSuperview];
                //跳转上传视频界面
                if (_isPlayer){
                UpLoadVideoViewController *uploadVideoVC = [[UpLoadVideoViewController alloc]init];
                    uploadVideoVC.eventsId = self.eventsId;
                    UINavigationController *uploadVideoNav = [[UINavigationController alloc]initWithRootViewController:uploadVideoVC];
                [self presentViewController:uploadVideoNav animated:YES completion:nil];
                }
                else {
                    //跳转订单列表页面
                    OrderListViewController *orderListVC = [[OrderListViewController alloc]init];
                    [self.navigationController pushViewController:orderListVC animated:YES];
                }
            }];
        }
        else {
            [self showAlert:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.5 animations:^{
        _payOrderView.center = CGPointMake(screen_width / 2, screen_height + 175);
        
    } completion:^(BOOL finished) {
        [_grayBackground removeFromSuperview];
        [_payOrderView removeFromSuperview];
        //跳转我的订单
    }];
}


#pragma tableView 的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 1;
    }
    else if (section == 1) {
        return 2;
    }
    else {
        if (dataSource.count>0){
        return dataSource.count;
        }
        else {
            return 1;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = _eventsTitle;
        cell.userInteractionEnabled = NO;

        return cell;
    }
    else if (indexPath.section==1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"phoneCell"];
        if (cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"phoneCell"];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"手机号码";
            if (_phoneNum){
                _phoneNum = [_phoneNum stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                cell.detailTextLabel.text = _phoneNum;
            }
            cell.userInteractionEnabled = NO;
            return cell;
        } else {
            cell.textLabel.text = @"姓名";
            if ([UserInfo getUserInfo][@"nick_name"]){
            cell.detailTextLabel.text = [UserInfo getUserInfo][@"nick_name"];
            }
            cell.userInteractionEnabled = NO;

            return cell;
        }
    }
    else {
        if (dataSource.count>0){
            TicketTableViewCell *ticketCell = [tableView dequeueReusableCellWithIdentifier:@"ticketCell" forIndexPath:indexPath];
            ticketCell.orderModel = dataSource[indexPath.row];
            ticketCell.selectedBackgroundView = [[UIView alloc]initWithFrame:ticketCell.frame];
            ticketCell.selectedBackgroundView.backgroundColor = ThemeColor;
            return ticketCell;
        }
        else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noTicketCell"];
            if (cell == nil){
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"noTicketCell"];
            }
            cell.textLabel.text = @"暂无票券,请选择其他报名方式";
            cell.userInteractionEnabled = NO;
            return cell;
        }
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2){
        return 100;
    }
    else {
        return 60;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2){
        OrderModel *orderModel = dataSource[indexPath.row];
        _footerView.totalPriceLb.text = [NSString stringWithFormat:@"￥%@",orderModel.price];
        _footerView.commitOrderBtn.enabled = YES;
        _footerView.commitOrderBtn.backgroundColor = ThemeColor;
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
