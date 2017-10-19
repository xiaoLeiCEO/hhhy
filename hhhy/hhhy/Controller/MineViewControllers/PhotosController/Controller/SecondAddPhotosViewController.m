//
//  SecondAddPhotosViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/27.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "SecondAddPhotosViewController.h"

@interface SecondAddPhotosViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *authorityArr;
    NSArray *themeArr;
}
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation SecondAddPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    authorityArr = @[@"所有人可见",@"好友可见",@"输入密码可见",@"仅自己可见"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    [self.view addSubview:self.tableView];
    
    
}

-(void)rightBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
    [_delegate sendMessage:[NSString stringWithFormat:@"%ld",[_tableView indexPathForSelectedRow].row]];
}

-(UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return authorityArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
        cell.textLabel.text = authorityArr[indexPath.row];
    
    if (indexPath.row==0){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    for (UITableViewCell *cell in [tableView visibleCells]) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
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
