//
//  PhotosViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/19.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoCollectionViewCell.h"
#import "PhotosModel.h"
#import "PhotosEditViewController.h"
#import "WLPreviewPhotoViewController.h"
#import "WLPhotoViewController.h"
#import "WLPhotoFileViewController.h"
#import "UploadPictureViewController.h"

@interface PhotosViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSMutableArray *photoArr;
    NSMutableArray *imageArr;
}
@property (nonatomic,strong) UICollectionView *photoCollectionView;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"相片";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    photoArr = [[NSMutableArray alloc]init];
    imageArr = [[NSMutableArray alloc]init];
    [self createUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectPhotos:) name:@"selectPhotos" object:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [photoArr removeAllObjects];
    [self loadData];

}

-(void)selectPhotos:(NSNotification *)notification{
    UploadPictureViewController *uploadPictureVC = [[UploadPictureViewController alloc]init];
    uploadPictureVC.albumId = _albumId;
    [imageArr addObjectsFromArray:notification.userInfo[@"selectPhotos"]];
    uploadPictureVC.imageArr = imageArr;
    [self.navigationController pushViewController:uploadPictureVC animated:YES];
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"selectPhotos" object:nil];
    
}

-(void)rightItemAction{
    PhotosEditViewController *photoEditVC = [[PhotosEditViewController alloc]init];
    photoEditVC.albumId = _albumId;
    UINavigationController *phtotsEditNav = [[UINavigationController alloc]initWithRootViewController:photoEditVC];
    [self presentViewController:phtotsEditNav animated:YES completion:nil];
}

-(void)createUI{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    _photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) collectionViewLayout:flowLayout];
    _photoCollectionView.backgroundColor = [UIColor whiteColor];
    _photoCollectionView.delegate = self;
    _photoCollectionView.dataSource = self;
    [_photoCollectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"photoCell"];
    [self.view addSubview:_photoCollectionView];
    
}

-(void)loadData{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"act"] = @"pic_list";
    parameters[@"token"] = [UserInfo getToken];
    parameters[@"album_id"] = _albumId;
    
    [ZMCHttpTool postWithUrl:WLMinePhotosURL parameters:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]){
            for (NSDictionary *dic in responseObject[@"data"][@"list"]){
                PhotosModel *photosModel = [[PhotosModel alloc]init];
                [photosModel setValuesForKeysWithDictionary:dic];
                [photoArr addObject:photosModel];
            }
            [_photoCollectionView reloadData];
        }
        else {
        
        }
    } failure:^(NSError *error) {
        
    }];
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return photoArr.count + 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionViewCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    if (indexPath.row==0){
        [photoCell.selectBtn removeFromSuperview];
        photoCell.photoImageView.image = [UIImage imageNamed:@"addImage"];
    }
    else {
        photoCell.photosModel = photoArr[indexPath.row-1];

    }
    return photoCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0){
        //跳转上传图片
        WLPhotoFileViewController *photoFileVC = [[WLPhotoFileViewController alloc]init];
        UINavigationController *photoFileNav = [[UINavigationController alloc]initWithRootViewController:photoFileVC];
        WLPhotoViewController *photoVC = [[WLPhotoViewController alloc]init];
        [photoFileNav pushViewController:photoVC animated:YES];
        [self presentViewController:photoFileNav animated:NO completion:nil];
    }
    else {
        WLPreviewPhotoViewController *wlPhotoPreviewVC = [[WLPreviewPhotoViewController alloc]init];
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        for (PhotosModel *photosModel in photoArr){
            [tempArr addObject:photosModel.path];
        }
        wlPhotoPreviewVC.previewPhotosArr = tempArr;
        wlPhotoPreviewVC.indexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:0];
        [self.navigationController pushViewController:wlPhotoPreviewVC animated:YES];
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((screen_width-3*5)/4, (screen_width-3*5)/4);
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
