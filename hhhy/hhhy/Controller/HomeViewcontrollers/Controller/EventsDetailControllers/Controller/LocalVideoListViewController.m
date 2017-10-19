//
//  LocalVideoListViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/8/8.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "LocalVideoListViewController.h"
#import "LocalVideoListCollectionViewCell.h"
#import "UploadImg.h"
#import <Photos/Photos.h>
#import "VideoPlayViewController.h"

@interface LocalVideoListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSMutableArray *thumbVideoArr; //存放视频第一帧图
    NSMutableArray *selectVideoArr; //存放选中的视频
    NSMutableArray *videoArr; //存放视频
    NSMutableArray *selectThumbVideoArr; //存放选中视频的第一帧图
    NSMutableArray *selectRow; //存放选中的第几行

    PHFetchResult *assetsResult;

}
@property (nonatomic,strong) UICollectionView *photoCollectionView;
@property (nonatomic, strong) AVPlayer *player;

@end

@implementation LocalVideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    thumbVideoArr = [[NSMutableArray alloc]init];
    selectVideoArr = [[NSMutableArray alloc]init];
    videoArr = [[NSMutableArray alloc]init];
    selectRow = [[NSMutableArray alloc]init];
    selectThumbVideoArr = [[NSMutableArray alloc]init];
    

    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    //如果用户开启访问相册权限
    if ([UploadImg photosAuthority]){
        [self createUI];
        [self getVideo];
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
    [_photoCollectionView registerNib:[UINib nibWithNibName:@"LocalVideoListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"localVideoListCell"];
    [self.view addSubview:_photoCollectionView];
    
}



//取消按钮
-(void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//获取相册中的视频第一帧图
-(void)getVideo{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    assetsResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:options];
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc]init];
    imageRequestOptions.version = PHImageRequestOptionsVersionOriginal;
    imageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    imageRequestOptions.synchronous = YES;
                  for (int i = 0;i<assetsResult.count;i++) {
            //获取视频的第一帧图
             [[PHImageManager defaultManager] requestImageForAsset:assetsResult[i] targetSize:CGSizeMake((screen_width-3*5)/4*scale_screen, (screen_width-3*5)/4*scale_screen) contentMode:PHImageContentModeAspectFit options:imageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                 
                 if (result){
                     [thumbVideoArr addObject:result];
                 }
                 
                 if (i==assetsResult.count-1){
                     [_photoCollectionView reloadData];
                 }
             }];

                      
        }
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return thumbVideoArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LocalVideoListCollectionViewCell *localVideoListCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"localVideoListCell" forIndexPath:indexPath];
    PHVideoRequestOptions *options2 = [[PHVideoRequestOptions alloc] init];
    options2.deliveryMode=PHVideoRequestOptionsDeliveryModeAutomatic;
    
    [[PHImageManager defaultManager] requestAVAssetForVideo:assetsResult[indexPath.row] options:options2 resultHandler:^(AVAsset*_Nullable asset,AVAudioMix*_Nullable audioMix,NSDictionary*_Nullable info) {
        [selectVideoArr addObject:asset];
        CMTime durationV = asset.duration;
        NSUInteger dTotalSeconds = CMTimeGetSeconds(durationV);
        NSUInteger dHours = floor(dTotalSeconds / 3600);
        NSUInteger dMinutes = floor(dTotalSeconds % 3600 / 60);
        NSUInteger dSeconds = floor(dTotalSeconds % 3600 % 60);
        NSString *videoDurationText = [NSString stringWithFormat:@"%lu:%02lu:%02lu",(unsigned long)dHours, (unsigned long)dMinutes, (unsigned long)dSeconds];
        dispatch_async(dispatch_get_main_queue(), ^{
            localVideoListCell.durationLabel.text = videoDurationText;

        });
    }];
    
    localVideoListCell.localVideoImageView.image = thumbVideoArr[indexPath.row];
    
    return localVideoListCell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoPlayViewController *videoPlayVC = [[VideoPlayViewController alloc]init];
    videoPlayVC.index = indexPath.row;
    [self.navigationController pushViewController:videoPlayVC animated:YES];
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
