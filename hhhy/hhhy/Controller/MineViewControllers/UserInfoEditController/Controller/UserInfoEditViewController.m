//
//  UserInfoEditViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/18.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "UserInfoEditViewController.h"
#import "NSString+checkTool.h"

@interface UserInfoEditViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *editName;
}

@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation UserInfoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    editName = @[@"nick_name",@"sex",@"mobile_phone"];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    if (_index==1){
        [self.view addSubview:self.tableView];
    }
    else {
        [self.view addSubview:self.textField];
        
    }
}

-(UITextField *)textField{
    if (!_textField){
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 74, screen_width-20, 30)];
        _textField.text = _defaultText;
    }
    return _textField;
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

-(void)rightBtnAction{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"act"] = @"edit_info";
    parameters[@"token"] = [UserInfo getToken];
    parameters[@"set_name"] = editName[_index];
    if (_index==0){
        //昵称页面
        parameters[@"set_value"] = self.textField.text;
    }
    else if (_index == 1){
        //性别页面
        parameters[@"set_value"] = [NSString  stringWithFormat:@"%ld",[_tableView indexPathForSelectedRow].row];
    }
    else{
        //修改手机号页面
        if ([self.textField.text isUsableMobile]){
            parameters[@"set_value"] = self.textField.text;
        }
        else {
            [self showAlert:@"请输入正确的手机号"];
        }
    }
    [self showProgressHud:MBProgressHUDModeIndeterminate message:nil];
    [ZMCHttpTool postWithUrl:WLUserInfoURL parameters:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]){
            [self hideProgressHud];
            if (_index==1){
                //性别页面
                [_delegate sendMessage:@[@"女",@"男",@"保密"][[_tableView indexPathForSelectedRow].row]];
            }
            else{
                //修改手机号页面                //昵称页面
                [_delegate sendMessage:self.textField.text];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            
        }
    } failure:^(NSError *error) {
        
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (indexPath.row==0){
        cell.textLabel.text = @"女";
    }
    else if (indexPath.row==1){
        cell.textLabel.text = @"男";
    }
    else {
        cell.textLabel.text = @"保密";
    }
    
    if ([cell.textLabel.text isEqualToString:_defaultText]){
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
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
