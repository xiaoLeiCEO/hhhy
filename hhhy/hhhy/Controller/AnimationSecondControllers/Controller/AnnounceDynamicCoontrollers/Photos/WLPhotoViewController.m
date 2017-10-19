//
//  WLPhotoViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/12.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "WLPhotoViewController.h"
#import <Photos/Photos.h>
#import "ViewMacro.h"
#import "PhotoCollectionViewCell.h"
#import "WLPhotoFileViewController.h"
#import "UploadImg.h"
#import "WLPreviewPhotoViewController.h"
@interface WLPhotoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSMutableArray *thumbPhotoArr;
    NSMutableArray *selectPhotosArr;
    NSMutableArray *photoIdentifierArr;
}
@property (nonatomic,strong) UICollectionView *photoCollectionView;

@end

@implementation WLPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    thumbPhotoArr = [[NSMutableArray alloc]init];
    selectPhotosArr = [[NSMutableArray alloc]init];
    photoIdentifierArr = [[NSMutableArray alloc]init];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    //如果用户开启访问相册权限
    if ([UploadImg photosAuthority]){
        [self isPhotosListViewController];
        [self createUI];

    }
    else {
        // 无权限,提示用户开启权限
        NSString *tipTextWhenNoPhotosAuthorization;
        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
        tipTextWhenNoPhotosAuthorization = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
        // 展示提示语
        [self showAlert:tipTextWhenNoPhotosAuthorization];
    }
}



-(void)createUI{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    _photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height-60) collectionViewLayout:flowLayout];
    _photoCollectionView.backgroundColor = [UIColor whiteColor];
    _photoCollectionView.delegate = self;
    _photoCollectionView.dataSource = self;
    [_photoCollectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"photoCell"];
    [self.view addSubview:_photoCollectionView];
    
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, screen_height- 60, screen_width, 60)];
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(screen_width - 70, 10, 60, 40)];
    [sureBtn setTitle:@"确定" forState:normal];
    [sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.tintColor = [UIColor whiteColor];
    sureBtn.backgroundColor = ThemeColor;
    [footerView addSubview:sureBtn];
    [self.view addSubview:footerView];
}



-(void)showAlert:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示消息" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];
}

//判断是从发布页面跳转还是从相册列表页跳转
-(void)isPhotosListViewController{
    if (_photoIdentifier){
        [self getPhotosThumbImage];
    }
    else{
        //按资源的创建时间排序
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        //获取相机胶卷
        PHAssetCollection *collection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
        _photoIdentifier = collection.localIdentifier;
        [self getPhotosThumbImage];
    }
}


//获取相片缩略图
-(void)getPhotosThumbImage {
    PHAssetCollection *assectCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[_photoIdentifier] options:nil].lastObject;
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assectCollection options:nil];

    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc]init];
    imageRequestOptions.version = PHImageRequestOptionsVersionOriginal;
    imageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    for (int i = 0;i<assets.count;i++){
        [[PHImageManager defaultManager] requestImageForAsset:assets[i] targetSize:CGSizeMake((screen_width-3*5)/4*scale_screen, (screen_width-3*5)/4*scale_screen) contentMode:PHImageContentModeAspectFit options:imageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result){
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                dic[@"image"] = result;
                NSLog(@"%f",result.size.width);
                dic[@"isSelect"] = @"0";
                [thumbPhotoArr addObject:dic];
                [photoIdentifierArr addObject:assets[i].localIdentifier];
            }
            if (i==assets.count-1){
                NSLog(@"%@", info);
                NSLog(@"%@", result);
                [_photoCollectionView reloadData];
            }
        }];
    }

}

//确定按钮
-(void)sureBtnAction{
    if (selectPhotosArr.count>0){
        
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsWithLocalIdentifiers:selectPhotosArr options:nil];
        for (PHAsset *asset in assets){
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                // 排除取消，错误，低清图三种情况，即已经获取到了高清图时，把这张高清图缓存到 _originImage 中
                BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                if (downloadFinined) {
                    [arr addObject:result];
                    if (arr.count == selectPhotosArr.count){
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectPhotos" object:nil userInfo:[NSDictionary dictionaryWithObject:arr forKey:@"selectPhotos"]];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }
            }];
        }

    }
}

//取消按钮
-(void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return thumbPhotoArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionViewCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    photoCell.photoImageView.image = thumbPhotoArr[indexPath.row][@"image"];
    photoCell.selectBtn.tag = 200+indexPath.row;
    if ([thumbPhotoArr[indexPath.row][@"isSelect"] isEqualToString:@"1"]){
        photoCell.selectBtn.selected = YES;
    }
    else {
        photoCell.selectBtn.selected = NO;
    }

    [photoCell.selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return photoCell;
}

-(void)selectBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected){
        [selectPhotosArr addObject:photoIdentifierArr[sender.tag - 200]];
        thumbPhotoArr[sender.tag - 200][@"isSelect"] = @"1";
    }
    else {
        [selectPhotosArr removeObject:photoIdentifierArr[sender.tag - 200]];
        thumbPhotoArr[sender.tag - 200][@"isSelect"] = @"0";

    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WLPreviewPhotoViewController *wlPhotoPreviewVC = [[WLPreviewPhotoViewController alloc]init];
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in thumbPhotoArr){
        [tempArr addObject:dic[@"image"]];
    }
    wlPhotoPreviewVC.previewPhotosArr = tempArr;
    wlPhotoPreviewVC.indexPath = indexPath;
    [self.navigationController pushViewController:wlPhotoPreviewVC animated:YES];
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
