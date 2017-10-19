//
//  RechargeViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/19.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "RechargeViewController.h"
#import "PayViewController.h"
#import "TransactionViewController.h"

@interface RechargeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"钱包";
    [self createUI];
}

-(void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0){
        return 2;
    }
    else {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    if (indexPath.section==0){
        if (indexPath.row==0){
            cell.textLabel.text = @"余额";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",_balance];
        }
        else {
            cell.textLabel.text = @"交易记录";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else {
        cell.textLabel.text = @"充值";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0){
        if (indexPath.row==1){
            //交易记录界面
            TransactionViewController *transactionVC = [[TransactionViewController alloc]init];
            [self.navigationController pushViewController:transactionVC animated:YES];
        }

    }
    else {
        //充值
        PayViewController *payVC = [[PayViewController alloc]init];
        [self.navigationController pushViewController:payVC animated:YES];
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
