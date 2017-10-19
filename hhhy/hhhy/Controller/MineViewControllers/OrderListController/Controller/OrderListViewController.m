//
//  OrderListViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/20.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "OrderListViewController.h"
#import "MyOrderTableViewCell.h"
#import "PayOrderView.h"
@interface OrderListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *dataSource;
}
@property (nonatomic,strong) UIView *grayBackground;
@property (nonatomic,copy) NSString *orderSn;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) PayOrderView *payOrderView;
@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataSource = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的订单";
    [self createUI];
    [self loadData];
}

-(void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableView];
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
    [dataSource removeAllObjects];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"act"] = @"order_list";
    parameters[@"token"] = [UserInfo getToken];
    [ZMCHttpTool postWithUrl:WLOrderURL parameters:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]){
            for (NSDictionary *dic in responseObject[@"data"][@"list"]){
                OrderListModel *orderListModel = [[OrderListModel alloc]init];
                [orderListModel setValuesForKeysWithDictionary:dic];
                [dataSource addObject:orderListModel];
            }
            [_tableView reloadData];
            
        }
        else {
            
        }
    } failure:^(NSError *error) {
        
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 94;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 45)];
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 35)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    //付款、提醒发货按钮
    UIButton *payMoneyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    payMoneyBtn.frame = CGRectMake(screen_width - 80, 5, 70, 25);
    payMoneyBtn.layer.cornerRadius = 10;
    payMoneyBtn.layer.borderWidth = 1;
    payMoneyBtn.layer.borderColor = RGBColor(242, 108, 78).CGColor;
    [payMoneyBtn setTitleColor:RGBColor(242, 108, 78) forState:normal];
    payMoneyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    payMoneyBtn.tag = section + 100;
    
    if (dataSource){
        OrderListModel *orderListModel = dataSource[section];
        if  ([orderListModel.pay_status isEqualToString:@"0"]){
            [payMoneyBtn setTitle:@"去支付" forState:normal];
        }
        else if ([orderListModel.pay_status isEqualToString:@"1"]){
            [payMoneyBtn setTitle:@"付款中" forState:normal];
        }
        else {
            [payMoneyBtn setTitle:@"交易成功" forState:normal];

        }
    }
    [payMoneyBtn addTarget:self action:@selector(payMoneyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //删除按钮
    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    delBtn.frame = CGRectMake(screen_width - 80 - 80, 5, 70, 25);
    delBtn.layer.cornerRadius = 10;
    delBtn.layer.borderWidth = 1;
    delBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [delBtn setTitleColor:[UIColor lightGrayColor] forState:normal];
    delBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    delBtn.tag = section + 200;
    [delBtn setTitle:@"删除" forState:normal];
    [delBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:delBtn];
    [contentView addSubview:payMoneyBtn];
    [footerView addSubview:contentView];
    return footerView;
}

//删除按钮点击事件
-(void)delBtnClick:(UIButton *)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示消息" message:@"确认删除该订单吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSMutableDictionary *paramaters = [[NSMutableDictionary alloc]init];
                paramaters[@"act"] = @"del_order";
                paramaters[@"token"] = [UserInfo getToken];
                OrderListModel *orderListModel = dataSource[sender.tag - 200];
                paramaters[@"order_sn"] = orderListModel.order_sn;
                [ZMCHttpTool postWithUrl:WLOrderURL parameters:paramaters success:^(id responseObject) {
                    NSLog(@"%@", responseObject);
                    if ([responseObject[@"status"] isEqualToString:@"1"]){
                        //删除成功
                        NSLog(@"%ld", sender.tag - 200);
                        [dataSource removeObjectAtIndex:sender.tag - 200];
                        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sender.tag - 200];
                        [_tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];
                        [_tableView reloadData];
                        
                    }
                } failure:^(NSError *error) {
        
                }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:sure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}

//付款按钮点击事件
-(void)payMoneyBtnClick:(UIButton *)sender{
    
    if ([sender.currentTitle isEqualToString:@"去支付"]){
        OrderListModel *orderListModel = dataSource[sender.tag - 100];
        _orderSn = orderListModel.order_sn;
        [self.view addSubview:self.grayBackground];
        
        _payOrderView = [[NSBundle mainBundle]loadNibNamed:@"PayOrderView" owner:self options:nil].lastObject;
        _payOrderView.frame = CGRectMake(0, screen_height, screen_width, 350);
        _payOrderView.priceLabel.text = [NSString stringWithFormat:@"￥%@",orderListModel.price];
        
        if ([UserInfo getUserInfo][@"balance"]){
            _payOrderView.balanceLabel.text = [NSString stringWithFormat:@"￥%@",[UserInfo getUserInfo][@"balance"]];
        }
        
        [_payOrderView.payMoneyBtn addTarget:self action:@selector(payMoneyBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_payOrderView];
        
        [UIView animateWithDuration:0.5 animations:^{
            _payOrderView.center = CGPointMake(screen_width / 2, screen_height - 175);
        }];
        

    }
    
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
            [self loadData];
            [UIView animateWithDuration:0.5 animations:^{
                _payOrderView.center = CGPointMake(screen_width / 2, screen_height + 175);
            } completion:^(BOOL finished) {
                [_grayBackground removeFromSuperview];
                [_payOrderView removeFromSuperview];
            }];
        }
        else {
            
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
    }];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - 100, 5, 100, 30)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = RGBColor(242, 108, 78);
    if (dataSource){
        OrderListModel *orderListModel = dataSource[section];
        if  ([orderListModel.pay_status isEqualToString:@"0"]){
            label.text = @"等待买家付款";
        }
        else if ([orderListModel.pay_status isEqualToString:@"2"]){
            label.text = @"已付款";
        }
    }
    [headerView addSubview:label];
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndetif = @"myOrderCell";
    MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetif];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyOrderTableViewCell" owner:self options:nil]lastObject];
    }
    cell.orderlistModel = dataSource[indexPath.section];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
