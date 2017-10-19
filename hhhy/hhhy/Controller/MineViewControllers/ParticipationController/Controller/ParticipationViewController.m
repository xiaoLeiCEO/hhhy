//
//  ParticipationViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/31.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "ParticipationViewController.h"
#import "HomeHotTableViewCell.h"
#import "EventsDetailViewController.h"

@interface ParticipationViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *dataSource;
    int page;
}

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ParticipationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"参与";
    dataSource = [[NSMutableArray alloc]init];
    page = 1;
    [self createUI];
    [self loadData];
}

-(void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"HomeHotTableViewCell" bundle:nil] forCellReuseIdentifier:@"homeHotCell"];
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
    parameters[@"act"] = @"sign_list";
    parameters[@"token"] = [UserInfo getToken];
    parameters[@"page"] = [NSString stringWithFormat:@"%d",page];
    [ZMCHttpTool postWithUrl:WLTicketListURL parameters:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]){
            for (NSDictionary *dic in responseObject[@"data"][@"list"]){
                HomeHotModel *homeHotModel = [[HomeHotModel alloc]init];
                [homeHotModel setValuesForKeysWithDictionary:dic];
                [dataSource addObject:homeHotModel];
            }
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            [_tableView reloadData];
        }
        else {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeHotTableViewCell *homeHotCell = [tableView dequeueReusableCellWithIdentifier:@"homeHotCell" forIndexPath:indexPath];
    homeHotCell.homeHotModel = dataSource[indexPath.row];
    homeHotCell.selectionStyle = UITableViewCellSelectionStyleNone;

    return homeHotCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 132;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeHotModel *homeHotModel = dataSource[indexPath.row];
    EventsDetailViewController *eventsDetailVC = [[EventsDetailViewController alloc]init];
    eventsDetailVC.isSaiShi = NO;
    eventsDetailVC.eventsId = homeHotModel.eventsId;
    //    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:eventsDetailVC animated:YES];
    //    self.hidesBottomBarWhenPushed = NO;
    
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
