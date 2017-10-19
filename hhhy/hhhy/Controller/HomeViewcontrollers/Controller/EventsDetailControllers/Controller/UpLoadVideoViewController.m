
//
//  UpLoadVideoViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/8/5.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "UpLoadVideoViewController.h"
#import "LocalVideoListCollectionViewCell.h"
#import "LocalVideoListViewController.h"
#import "UploadImg.h"

@interface UpLoadVideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>{
    NSMutableArray *dataSource;
}

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UITextView *desTextView;
@property (nonatomic,strong) UILabel *placeHolderLabel;
@property (nonatomic,strong) UITextField *titleTf;

@end

@implementation UpLoadVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"上传视频";
    self.navigationController.navigationBar.barTintColor = ThemeColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = [UIColor whiteColor];
    
    dataSource = [[NSMutableArray alloc]init];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendSelectVideo:) name:@"selectVideo" object:nil];
    
    [self createUI];
}

-(void)createUI{
    
    _titleTf = [[UITextField alloc]initWithFrame:CGRectMake(10, 74, screen_width - 10, 30)];
    _titleTf.placeholder = @"请填写标题";
    _titleTf.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_titleTf];
    
    _desTextView = [[UITextView alloc]initWithFrame:CGRectMake(12, 74 + 30 + 12, screen_width-10, 100)];
    _desTextView.delegate = self;
    _placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 74 + 30 + 10 +6, 100, 21)];
    _placeHolderLabel.font = [UIFont systemFontOfSize:14];
    _placeHolderLabel.textColor = [UIColor lightGrayColor];
    _placeHolderLabel.text = @"写点什么吧...";
    [self.view addSubview:_desTextView];
    [self.view addSubview:_placeHolderLabel];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, _desTextView.frame.origin.y + _desTextView.frame.size.height + 10, screen_width, screen_height - _desTextView.frame.origin.y - _desTextView.frame.size.height - 10) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"LocalVideoListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"localVideoListCell"];
    [self.view addSubview:_collectionView];
    
}

-(void)leftBtnAction{
    UIAlertController *alertontroller = [UIAlertController alertControllerWithTitle:@"提示" message:@"选手必须要上传视频进行参赛，您确定放弃上传视频，如果放弃请稍后在活动或赛事详情页上传视频" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertontroller addAction:sureAction];
    [alertontroller addAction:cancelAction];
    [self presentViewController:alertontroller animated:YES completion:nil];
}


-(void)rightBtnAction:(UIBarButtonItem *)sender{
    sender.enabled = NO;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"token"] = [UserInfo getToken];
    parameters[@"hd_id"] = _eventsId;
    parameters[@"title"] = _titleTf.text;
    parameters[@"description"] = _desTextView.text;
    
    if (dataSource.count>0){
        [self showProgressHud:MBProgressHUDModeDeterminateHorizontalBar message:@"上传中..."];
        NSString * resultPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/output.mp4"];
        [UploadImg uploadVideo:WLUploadVideoURL withVideoPath:resultPath withParameters:parameters withVideoName:@"content" progress:^(NSProgress *uploadProgress) {
            
            [uploadProgress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
            
        } success:^(id responseObject) {
            NSLog(@"%@", responseObject);
            if ([responseObject[@"status"] isEqualToString:@"1"]){
                [self hideProgressHud];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else {
                sender.enabled = YES;
                [self hideProgressHud];
            }
        } failure:^(NSError *error) {
            sender.enabled = YES;
            [self hideProgressHud];

        }];
    }
    else {
        sender.enabled = YES;
        [self showAlert:@"请选择视频"];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context

{
    
    if ([keyPath isEqualToString:@"fractionCompleted"] && [object isKindOfClass:[NSProgress class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 在主线程中更新 UI
            NSProgress *progress = (NSProgress *)object;
            [MBProgressHUD HUDForView:self.view].progress = (float)progress.fractionCompleted;
        });
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""]) {
        _placeHolderLabel.hidden = YES;
    }
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        _placeHolderLabel.hidden = NO;
    }
    return YES;
}

-(void)sendSelectVideo:(NSNotification *)notification{
    [dataSource addObject:notification.userInfo];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_collectionView reloadData];
        
    });
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LocalVideoListCollectionViewCell *localVideoListCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"localVideoListCell" forIndexPath:indexPath];
    if (dataSource.count>0){
        localVideoListCell.localVideoImageView.image = dataSource[indexPath.row][@"image"];
        localVideoListCell.durationLabel.text = dataSource[indexPath.row][@"duration"];
    }
    else {
        localVideoListCell.localVideoImageView.image = [UIImage imageNamed:@"addImage"];
    }
    return localVideoListCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (dataSource.count==0){
        LocalVideoListViewController *localVideoListVC = [[LocalVideoListViewController alloc]init];
        UINavigationController *localVideoListNav = [[UINavigationController alloc]initWithRootViewController:localVideoListVC];
        [self presentViewController:localVideoListNav animated:YES completion:nil];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((screen_width-4*10)/4, (screen_width-4*10)/4);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectVideo" object:nil];
    
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
