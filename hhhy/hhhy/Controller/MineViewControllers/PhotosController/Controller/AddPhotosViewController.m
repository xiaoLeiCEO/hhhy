//
//  AddPhotosViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/26.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "AddPhotosViewController.h"
#import "SecondAddPhotosViewController.h"
#import "UploadImg.h"
#import "NSString+checkTool.h"
@interface AddPhotosViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SencondAddPhotosViewControllerDelegate>{
    NSArray *authorityArr;

}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITextField *photosNameTf;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic,strong) UIImage *photosImage;
@property (nonatomic,copy) NSString *authorityStr;
@end

@implementation AddPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"新建相册";
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemAction)];
    leftItem.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    _authorityStr = @"0";
    authorityArr = @[@"所有人可见",@"好友可见",@"输入密码可见",@"仅自己可见"];

    [self createUI];
}


-(void)createUI{
    
    _photosNameTf = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, screen_height, 50)];
    _photosNameTf.placeholder = @"填写相册名称";
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

//完成按钮点击事件
-(void)finishBtnAction{
    if (_photosImage) {
        if ([_photosNameTf.text isEmpty]){
            [self showAlert:@"请填写相册名称"];
        }
        else{
            NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
            if (_isEvents){
                parameter[@"token"] = [UserInfo getToken];
                parameter[@"act"] = @"add";
                parameter[@"hd_id"] = _eventsId;
                parameter[@"album_name"] = _photosNameTf.text;
                parameter[@"type"] = @"2";
                parameter[@"permission"] = _authorityStr;
            }
            else {
                parameter[@"token"] = [UserInfo getToken];
                parameter[@"act"] = @"add";
                parameter[@"album_name"] = _photosNameTf.text;
                parameter[@"type"] = @"1";
                parameter[@"permission"] = _authorityStr;
            }
            [UploadImg uploadImage:_photosImage withUrl:WLMinePhotosURL withParameters:parameter withImageName:@"pic"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else {
        [self showAlert:@"请选择相册封面"];
    }
}

-(void)leftItemAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)selectPhotosCover{
    
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





-(void)sendMessage:(NSString *)message{
    _authorityStr = message;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark UIImagePickerControllerDelegate
//选择图或者拍照后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *orignalImage = [info objectForKey:UIImagePickerControllerOriginalImage];//原图
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];//编辑后的图片
    //    [self startHUDmessage:@"正在上传.."];
    
    _photosImage = editedImage;
    // 拍照后保存原图片到相册中
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera && orignalImage) {
        UIImageWriteToSavedPhotosAlbum(orignalImage, self, nil, NULL);
    }
    //上传照片
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_photosNameTf resignFirstResponder];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0){
        return 1;
    }
    else {
        return 2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    if (indexPath.section==0){
        [cell.contentView addSubview:_photosNameTf];
    }
    else {
        if (indexPath.row==0){
        cell.textLabel.text = @"权限";
            cell.detailTextLabel.text = authorityArr[_authorityStr.integerValue];
        }
        else{
            cell.textLabel.text = @"选择相册封面";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1){
        if (indexPath.row==0){
            //权限
            SecondAddPhotosViewController *secondAddPhotosVC = [[SecondAddPhotosViewController alloc]init];
            secondAddPhotosVC.delegate = self;
            [self.navigationController pushViewController:secondAddPhotosVC animated:YES];
        }
        else {
            //选择相册封面
            [self selectPhotosCover];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0){
        return 60;
    }
    else {
        return 44;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==1){
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 70)];
        footerView.backgroundColor = [UIColor whiteColor];
        UIButton *finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, screen_width-20, 50)];
        [finishBtn setTitle:@"完成" forState:normal];
        [finishBtn addTarget:self action:@selector(finishBtnAction) forControlEvents:UIControlEventTouchUpInside];
        finishBtn.backgroundColor = ThemeColor;
        [finishBtn setTitleColor:[UIColor whiteColor] forState:normal];
        [footerView addSubview:finishBtn];
        return footerView ;
    }
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0){
        return 20;
    }
    else {
        return 70;
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
