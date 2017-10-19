//
//  MessageCollectionViewCell.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/4.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "MessageCollectionViewCell.h"
#import "WeMediaTableViewCell.h"
#import "CommonUrl.h"
#import "ZMCHttpTool.h"
#import "UserInfo.h"
#import "MessageWeMediaModel.h"
#import "MJRefresh.h"
@interface MessageCollectionViewCell()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataSource;
    int page;
}
@end

@implementation MessageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    page = 1;
    dataSource = [[NSMutableArray alloc]init];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [dataSource removeAllObjects];
        [self loadData];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page +=1;
        [self loadData];
    }];    UINib *nib = [UINib nibWithNibName:@"WeMediaTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"weMedia"];
    [self loadData];
}

-(void)loadData{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"act"] = @"list";
    parameters[@"token"] = [UserInfo getToken];
    NSLog(@"%@", [UserInfo getToken]);
    parameters[@"f"] = @"10";
    parameters[@"page"] = [NSString stringWithFormat:@"%d",page];
    [ZMCHttpTool postWithUrl:WLWeMediaArticleURL parameters:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]){
            NSMutableArray *dataArr = responseObject[@"data"][@"list"];
            for (NSDictionary *dic in dataArr){
                MessageWeMediaModel *messageWeMediaModel = [[MessageWeMediaModel alloc]init];
                [messageWeMediaModel setValuesForKeysWithDictionary:dic];
                [dataSource addObject:messageWeMediaModel];
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
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeMediaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weMedia" forIndexPath:indexPath];
    cell.messageWeMediaModel = dataSource[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageWeMediaModel *messageModel = dataSource[indexPath.section];
    [_delegate pushMessageDetailViewController:messageModel.content withUserId:messageModel.user_id];
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 230;
}

@end
