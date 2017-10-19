//
//  LogViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/15.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "LogViewController.h"
#import "DynamicTableViewCell.h"
#import "AnnounceDynamicViewController.h"
#import "WLPreviewPhotoViewController.h"
@interface LogViewController ()<UITableViewDelegate,UITableViewDataSource,DynamicTableViewCellDelegate>
{
    NSMutableArray *dataSource;
    CGFloat cellHeight;
    int page;
}
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    dataSource = [[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"日志";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    [self createUI];
    [self loadData];
}

-(void)loadData{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"act"] = @"list";
    parameters[@"token"] = [UserInfo getToken];
    parameters[@"page"] = [NSString stringWithFormat:@"%d",page];
    NSLog(@"%@", [UserInfo getToken]);
    [self showProgressHud:MBProgressHUDModeIndeterminate message:nil];
    [ZMCHttpTool postWithUrl:WLLogURL parameters:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]){
            [self hideProgressHud];
            NSArray *dataArr = responseObject[@"data"][@"list"];
            for (int i=0; i<dataArr.count;i++){
                DynamicModel* dynamicModel = [[DynamicModel alloc]init];
                [dynamicModel setValuesForKeysWithDictionary:dataArr[i]];
                [dataSource addObject:dynamicModel];
            }
            [_tableView reloadData];
            [_tableView.mj_footer endRefreshing];
            [_tableView.mj_header endRefreshing];
        }
        else {
            [self hideProgressHud];
            [self showProgressHud:MBProgressHUDModeText message:responseObject[@"msg"]];
            [self hideProgeressHudAfterDelay:1];
            [_tableView.mj_footer endRefreshing];
            [_tableView.mj_header endRefreshing];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [dataSource removeAllObjects];
        [self loadData];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page +=1;
        [self loadData];
    }];
    [_tableView registerNib:[UINib nibWithNibName:@"DynamicTableViewCell" bundle:nil] forCellReuseIdentifier:@"dynamicCell"];
    [self.view addSubview:_tableView];
}

//发布按钮点击事件
-(void)rightBtnAction{
    AnnounceDynamicViewController *announceDynamicVC = [[AnnounceDynamicViewController alloc]init];
    announceDynamicVC.isDynamic = NO;
    [self.navigationController pushViewController:announceDynamicVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 500;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DynamicTableViewCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:@"dynamicCell"];
    dynamicCell.delegate = self;
    dynamicCell.dynamicModel = dataSource[indexPath.row];
    cellHeight = dynamicCell->dynamicHeight;
    dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return dynamicCell;
}


-(void)showPreviewPhotosViewController:(NSArray *)arr withIndex:(NSInteger)index{
    WLPreviewPhotoViewController *previewPhotoVC = [[WLPreviewPhotoViewController alloc]init];
    previewPhotoVC.previewPhotosArr = arr;
    NSLog(@"%ld", (long)index);
    previewPhotoVC.indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.navigationController pushViewController:previewPhotoVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
