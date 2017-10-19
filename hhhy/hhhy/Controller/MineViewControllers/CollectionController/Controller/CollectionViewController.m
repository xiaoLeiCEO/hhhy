//
//  CollectionViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/19.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "CollectionViewController.h"
#import "EventsModel.h"
#import "EventsDetailViewController.h"
#import "HomeHotTableViewCell.h"
@interface CollectionViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int page;
    NSMutableArray *dataSource;
}
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    page = 1;
    dataSource = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"收藏";
    [self setTableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
    self.navigationController.navigationBarHidden = false;
}

-(void)loadData{
    //
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"act"] = @"list";
    parameters[@"token"] = [UserInfo getToken];
    parameters[@"page"] = [NSString stringWithFormat:@"%d",page];
    [ZMCHttpTool postWithUrl:WLCollectURL parameters:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"status"]  isEqualToString:@"1"]) {
            for (NSDictionary *dic in responseObject[@"data"][@"list"]){
                HomeHotModel *homeHotModel = [[HomeHotModel alloc]init];
                [homeHotModel setValuesForKeysWithDictionary:dic];
                [dataSource addObject:homeHotModel];
            }
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            [_tableView reloadData];
        }else {
            
        }
    } failure:^(NSError *error) {
    }];
    
}

-(void)setTableView{
    _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  132;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeHotTableViewCell *homeHotCell = [tableView dequeueReusableCellWithIdentifier:@"homeHotCell" forIndexPath:indexPath];
    homeHotCell.homeHotModel = dataSource[indexPath.row];
    homeHotCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return homeHotCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeHotModel *homeHotModel = dataSource[indexPath.row];
    EventsDetailViewController *eventsDetailVC = [[EventsDetailViewController alloc]init];
    if ([homeHotModel.mark isEqualToString:@"0"]){
    eventsDetailVC.isSaiShi = NO;
    }
    else {
        eventsDetailVC.isSaiShi = YES;
    }
    eventsDetailVC.eventsId = homeHotModel.eventsId;
    [self.navigationController pushViewController:eventsDetailVC animated:YES];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeHotModel *homeHotMoel = dataSource[indexPath.row];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"act"] = @"del";
    parameters[@"token"] = [UserInfo getToken];
    parameters[@"hd_id"] = homeHotMoel.eventsId;
    [ZMCHttpTool postWithUrl:WLCollectURL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"status"]  isEqualToString:@"1"]) {
            //删除收藏成功
            [dataSource removeObjectAtIndex:indexPath.row];
            [_tableView reloadData];
        }else {
            NSLog(@"%@",responseObject[@"msg"]);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
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
