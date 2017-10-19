//
//  TransactionViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/31.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "TransactionViewController.h"
#import "TransactionTableViewCell.h"

@interface TransactionViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *dataSource;
    int page;
}
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation TransactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"交易记录";
    dataSource = [[NSMutableArray alloc]init];
    page = 1;
    [self createUI];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"TransactionTableViewCell" bundle:nil] forCellReuseIdentifier:@"transactionCell"];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [dataSource removeAllObjects];
        [self loadData];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page +=1;
        [self loadData];
    }];
    [self.view addSubview:_tableView];
}

-(void)loadData{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"token"] = [UserInfo getToken];
    parameters[@"page"] = [NSString stringWithFormat:@"%d",page];
    
    [ZMCHttpTool postWithUrl:WLRecodeURL parameters:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]){
            for (NSDictionary *dic in responseObject[@"data"]){
                NSLog(@"%@", dic);
                TransactionModel *transactionModel = [[TransactionModel alloc]init];
                [transactionModel setValuesForKeysWithDictionary:dic];
                [dataSource addObject:transactionModel];
            }
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            [_tableView reloadData];
        }
        else {
            
        }
    } failure:^(NSError *error) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TransactionTableViewCell *transactionCell = [tableView dequeueReusableCellWithIdentifier:@"transactionCell" forIndexPath:indexPath];
    transactionCell.transactionModel = dataSource[indexPath.row];
    return transactionCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
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
