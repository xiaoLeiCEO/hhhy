//
//  HomeViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/1.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeHotTableViewCell.h"
#import "HomeCategoryTableViewCell.h"
#import "AnimtaionView.h"
#import "EventsDetailViewController.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataSource;
    int page;
}

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    dataSource = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"哈哈互娱";
    [self createUI];
    [self loadData];
}

-(void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
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
    parameters[@"mark"] = @"0";
    parameters[@"f"] = @"10";
    parameters[@"token"] = [UserInfo getToken];
    parameters[@"page"] = [NSString stringWithFormat:@"%d",page];
    [ZMCHttpTool postWithUrl:WLEventsListURL parameters:parameters success:^(id responseObject) {
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
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 2;
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section==0){
//        return 1;
//    }
//    else {
//        return dataSource.count;
//    }
    return dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0){
//        return 50 + 21 + 14*2;
//    }
//    else {
//        return 132;
//    }
    return 132;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0){
//        HomeCategoryTableViewCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell"];
//        if (categoryCell == nil){
//            categoryCell = [[HomeCategoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"categoryCell"];
//        }
//        for (int i=0;i<5;i++){
//            AnimtaionView *animationView = [[AnimtaionView alloc]init];
//            [animationView.btn addTarget:self action:@selector(animationViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        }
//        
//        categoryCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return categoryCell;
//    }
//    else {
//        HomeHotTableViewCell *homeHotCell = [tableView dequeueReusableCellWithIdentifier:@"homeHotCell" forIndexPath:indexPath];
//        homeHotCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return homeHotCell;
//    }
    HomeHotTableViewCell *homeHotCell = [tableView dequeueReusableCellWithIdentifier:@"homeHotCell" forIndexPath:indexPath];
    homeHotCell.homeHotModel = dataSource[indexPath.row];
    homeHotCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return homeHotCell;
}

//-(void)animationViewBtnAction:(UIButton *)sender{
//    
//}
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
