//
//  MineViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/1.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "MineViewController.h"
#import "MineModel.h"
#import "HomeCategoryTableViewCell.h"
#import "AnimtaionView.h"
#import "MineTableViewCell1.h"
#import "UserInfoViewController.h"
#import "UploadImg.h"
#import "DynamicViewController.h"
#import "LogViewController.h"
#import "CollectionViewController.h"
#import "SettingViewController.h"
#import "RechargeViewController.h"
#import "PhotosFileViewController.h"
#import "OrderListViewController.h"
#import "ParticipationViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,HomeCategoryTableViewCellDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MineModel *mineModel;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic,strong) UIImage *headImage;


@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的";
    [self createUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"MineTableViewCell1" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self.view addSubview:_tableView];
}

-(void)loadData{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"act"] = @"user_info";
    parameters[@"token"] = [UserInfo getToken];
    [ZMCHttpTool postWithUrl:WLUserInfoURL parameters:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]){
            [UserInfo setUserInfo:responseObject[@"data"][@"info"]];
            [UserInfo setPhoneNum:responseObject[@"data"][@"info"][@"mobile_phone"]];
            _mineModel = [[MineModel alloc]init];
            [_mineModel setValuesForKeysWithDictionary:responseObject[@"data"][@"info"]];
            [_tableView reloadData];
        }
        else {
        
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)uploadHeadImage{
    
    
    __block typeof (self) weak_self = self;
    
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    _picker.allowsEditing = YES;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
    UIAlertAction* fromPhotoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {
        weak_self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [weak_self presentViewController:weak_self.picker animated:YES completion:nil];
        NSLog(@"从相册选择");
    }];
    UIAlertAction* fromCameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault                                                             handler:^(UIAlertAction * action) {
        NSLog(@"相机");
        weak_self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;

        if (![UploadImg getCameraRecordPermisson]) {
            NSString *tips = @"请在iPhone的“设置-隐私-相机”中允许访问相机";
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:tips preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"确定");
            }];
            [alertController addAction:otherAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else {
            [weak_self presentViewController:weak_self.picker animated:YES completion:nil];
        }
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:fromCameraAction];
    [alertController addAction:fromPhotoAction];
    [self presentViewController:alertController animated:YES completion:nil];
}





#pragma mark HomeCategoryTableViewCellDelegate
-(void)sendButtonForAnimationViewTag:(NSInteger)tag{
    switch (tag) {
        case 200:
        {
            //相册
            PhotosFileViewController *photosVC = [[PhotosFileViewController alloc]init];
            photosVC.isEvents = NO;
            [self.navigationController pushViewController:photosVC animated:YES];
        }
            break;
        case 201:
        {
            //动态
            DynamicViewController *dynamicVC = [[DynamicViewController alloc]init];
            [self.navigationController pushViewController:dynamicVC animated:YES];
        }
            break;
        case 202:
        {
            //日志
            LogViewController *logVC = [[LogViewController alloc]init];
            [self.navigationController pushViewController:logVC animated:YES];
        }
            break;
        case 203:
        {
            //收藏
            CollectionViewController *collectionVC = [[CollectionViewController alloc]init];
            [self.navigationController pushViewController:collectionVC animated:YES];   
        }
            break;
        case 204:
        {
            //设置
            SettingViewController *settingVC = [[SettingViewController alloc]init];
            [self.navigationController pushViewController:settingVC animated:YES];
        }
            break;
        default:
            break;
    }
}


#pragma mark UIImagePickerControllerDelegate
//选择图或者拍照后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *orignalImage = [info objectForKey:UIImagePickerControllerOriginalImage];//原图
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];//编辑后的图片
//    [self startHUDmessage:@"正在上传.."];
    
    _headImage = editedImage;
    // 拍照后保存原图片到相册中
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera && orignalImage) {
        UIImageWriteToSavedPhotosAlbum(orignalImage, self, nil, NULL);
    }
    //上传照片
    [picker dismissViewControllerAnimated:YES completion:^{
        if (editedImage) {
            [UploadImg uploadImage:editedImage withUrl:WLUploadHeadImgURL withParameters:@{@"token":[UserInfo getToken]} withImageName:@"photo"];
        }
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1){
        return 3;
    }
    else {
        return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0){
        MineTableViewCell1 *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        
        if (_headImage){
            cell1.headImageView.image = _headImage;
        }
        else {
            [cell1.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DOMAINURL,_mineModel.photo]] placeholderImage:[UIImage imageNamed:@"paishe"]];
        }

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadHeadImage)];
        [cell1.headImageView addGestureRecognizer:tap];
        cell1.nameLabel.text = _mineModel.nick_name;
        return cell1;
    }
    else if (indexPath.section==1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        if (indexPath.row == 0){
            cell.textLabel.text = @"订单";
            cell.imageView.image = [UIImage imageNamed:@"dd"];
            return cell;
            
        }
        else if (indexPath.row==1){
            cell.textLabel.text = @"钱包";
            cell.imageView.image = [UIImage imageNamed:@"chongZhi"];
            return cell;
        }
        else {
            cell.textLabel.text = @"参与";
            cell.imageView.image = [UIImage imageNamed:@"cy"];
            return cell;
        }
    }
    else {
        HomeCategoryTableViewCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell"];
        if (categoryCell == nil){
            categoryCell = [[HomeCategoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"categoryCell"];
        }
        categoryCell.delegate = self;
        categoryCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return categoryCell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0){
        //跳转个人信息页面
        UserInfoViewController *userInfoVC = [[UserInfoViewController alloc]init];
        userInfoVC.mineModel = self.mineModel;
        [self.navigationController pushViewController:userInfoVC animated:YES];
    }
    else if (indexPath.section==1){
        if (indexPath.row == 0){
            //跳转订单页面
            OrderListViewController *orderListVC = [[OrderListViewController alloc]init];
            [self.navigationController pushViewController:orderListVC animated:YES];
        }
        else if (indexPath.row == 1){
            //跳转充值页面
            RechargeViewController *rechargeVC = [[RechargeViewController alloc]init];
            rechargeVC.balance = _mineModel.balance;
            [self.navigationController pushViewController:rechargeVC animated:YES];
        }
        else {
            //跳转参与页面
            ParticipationViewController *participationVC = [[ParticipationViewController alloc]init];
            [self.navigationController pushViewController:participationVC animated:YES];
        }
    }
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0){
        return 105;
    }
    else if (indexPath.section == 1){
        return 55;
    }
    else {
        return 218;
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
