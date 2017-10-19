//
//  PlayerListViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/8/1.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "PlayerListViewController.h"
#import "PlayerListTableViewCell.h"

@interface PlayerListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *dataSource1;
    NSMutableArray *dataSource2;
    int page;
    
}
@property (nonatomic,copy) NSString *type;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UISegmentedControl *segment;
@end

@implementation PlayerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _segment = [[UISegmentedControl alloc]initWithItems:@[@"选手",@"观众"]];
    [_segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    _segment.frame = CGRectMake(0, 0, 60, 30);
    _segment.tintColor = [UIColor whiteColor];
    _segment.selectedSegmentIndex = 0;
    self.navigationItem.titleView = _segment;
    dataSource1 = [[NSMutableArray alloc]init];
    dataSource2 = [[NSMutableArray alloc]init];

    _type = @"1";
    page = 1;
    [self createUI];
    [self loadData];
}

-(void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [dataSource1 removeAllObjects];
        [dataSource2 removeAllObjects];

        [self loadData];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page +=1;
        [self loadData];
    }];
    
    [_tableView registerNib:[UINib nibWithNibName:@"PlayerListTableViewCell" bundle:nil] forCellReuseIdentifier:@"playerListCell"];
    [self.view addSubview:_tableView];
}

-(void)loadData{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"token"] = [UserInfo getToken];
    parameters[@"hd_id"] = _eventsId;
    parameters[@"page"] = [NSString stringWithFormat:@"%d",page];
    parameters[@"type"] = _type;
    [ZMCHttpTool postWithUrl:WLPlayerListURL parameters:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]){
            for (NSDictionary *dic in responseObject[@"data"]){
                PlayerListModel *playerListModel = [[PlayerListModel alloc]init];
                [playerListModel setValuesForKeysWithDictionary:dic];
                if ([_type isEqualToString:@"1"]){
                    [dataSource1 addObject:playerListModel];
                }
                else {
                    [dataSource2 addObject:playerListModel];
                }
            }
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            [_tableView reloadData];
        }
        else {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            [_tableView reloadData];

        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)segmentAction:(UISegmentedControl *)sender{
    switch (sender.selectedSegmentIndex) {
        case 0:
            _type = @"1";
            if (dataSource1.count==0){
                [self loadData];
            }
            else {
                [_tableView reloadData];
            }
            break;
        case 1:
            _type = @"2";
            if (dataSource2.count==0){
                [self loadData];
            }
            else {
                [_tableView reloadData];
            }
            break;
            
        default:
            break;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_segment.selectedSegmentIndex == 0){
        return  dataSource1.count;

    }
    else {
        return  dataSource2.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlayerListTableViewCell *palyerListCell = [tableView dequeueReusableCellWithIdentifier:@"playerListCell" forIndexPath:indexPath];
    if (_segment.selectedSegmentIndex == 0){
        palyerListCell.payerListModel = dataSource1[indexPath.row];
        
    }
    else {
        palyerListCell.payerListModel = dataSource2[indexPath.row];
    }
    return palyerListCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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
