//
//  AnnounceDynamicViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/11.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "AnnounceDynamicViewController.h"
#import "WLPhotoViewController.h"
#import "WLPhotoFileViewController.h"
#import "UploadImg.h"
#import "AnnouncePhotoCollectionViewCell.h"
@interface AnnounceDynamicViewController ()<UITextViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *imageArr;
}

@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation AnnounceDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    imageArr = [[NSMutableArray alloc]init];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    [self createUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectPhotos:) name:@"selectPhotos" object:nil];

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"selectPhotos" object:nil];

}



-(void)createUI{
    _writeTf.delegate = self;

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, _writeTf.frame.origin.y + _writeTf.frame.size.height + 10, screen_width, screen_height - _writeTf.frame.origin.y - _writeTf.frame.size.height - 10) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"AnnouncePhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"announcePhotoCell"];
    [self.view addSubview:_collectionView];
}


//发布
-(void)rightBtnAction{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"act"] = @"add_dt";
    parameters[@"token"] = [UserInfo getToken];
    parameters[@"content"] = _writeTf.text;
    if (_isDynamic){
        //动态发布
        [ZMCHttpTool postWithUrl:WLLogURL parameters:parameters success:^(id responseObject) {
            NSLog(@"%@", responseObject);
            if([responseObject[@"status"] isEqualToString:@"1"]){
                [self.navigationController popViewControllerAnimated:YES];
                NSLog(@"%@", responseObject[@"data"][@"id"]);
                if (imageArr.count >0) {
                    for (UIImage *selectPhtoto in imageArr){
                        NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
                        parameter[@"token"] = [UserInfo getToken];
                        parameter[@"act"] = @"upload_pic";
                        parameter[@"type"] = @"2";
                        parameter[@"id"] = responseObject[@"data"][@"id"];
                        [UploadImg uploadImage:selectPhtoto withUrl:WLLogURL withParameters:parameter withImageName:@"pic"];
                    }
                }
            }
            else {
                
            }
        } failure:^(NSError *error) {
            
        }];
        
    }
    else {
        //日志发布
        parameters[@"act"] = @"fabu";
        parameters[@"title"] = @" ";
        [ZMCHttpTool postWithUrl:WLLogURL parameters:parameters success:^(id responseObject) {
            NSLog(@"%@", responseObject);
            if([responseObject[@"status"] isEqualToString:@"1"]){
                [self.navigationController popViewControllerAnimated:YES];
                NSLog(@"%@", responseObject[@"data"][@"myblog_id"]);
                if (imageArr.count >0) {
                    for (UIImage *selectPhtoto in imageArr){
                        NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
                        parameter[@"token"] = [UserInfo getToken];
                        parameter[@"act"] = @"upload_pic";
                        parameter[@"type"] = @"1";
                        parameter[@"id"] = responseObject[@"data"][@"myblog_id"];
                        [UploadImg uploadImage:selectPhtoto withUrl:WLLogURL withParameters:parameter withImageName:@"pic"];
                    }
                }
            }
            else {
                
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
}



-(void)selectPhotos:(NSNotification *)notification{
    [imageArr addObjectsFromArray:notification.userInfo[@"selectPhotos"]];
    [_collectionView reloadData];
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_writeTf resignFirstResponder];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return imageArr.count +1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AnnouncePhotoCollectionViewCell *announcePhotoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"announcePhotoCell" forIndexPath:indexPath];
    if (indexPath.row==0){
        announcePhotoCell.photoImageView.image = [UIImage imageNamed:@"addImage"];
    }
    else {
        announcePhotoCell.photoImageView.image = imageArr[indexPath.row-1];
    }
    return announcePhotoCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0){
        WLPhotoFileViewController *photoFileVC = [[WLPhotoFileViewController alloc]init];
        UINavigationController *photoFileNav = [[UINavigationController alloc]initWithRootViewController:photoFileVC];
        WLPhotoViewController *photoVC = [[WLPhotoViewController alloc]init];
        [photoFileNav pushViewController:photoVC animated:YES];
        [self presentViewController:photoFileNav animated:NO completion:nil];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((screen_width-4*10)/4, (screen_width-4*10)/4);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
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
