//
//  WLPhotoFileViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/12.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "WLPhotoFileViewController.h"
#import "WLPhotoViewController.h"
#import "ViewMacro.h"
#import <Photos/Photos.h>
@interface WLPhotoFileViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *photosNameArr;
    NSMutableArray *photosThumbArr;
    NSMutableArray *photosIdentifiersArr; //存放相册标识符
}
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation WLPhotoFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"照片";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    photosIdentifiersArr = [[NSMutableArray alloc]init];
    photosNameArr = [[NSMutableArray alloc]init];
    photosThumbArr = [[NSMutableArray alloc]init];
    [self getSpecifyPHAssetCollectionType];
    [self createUI];
}


//获取指定类型的相册
- (void)getSpecifyPHAssetCollectionType
{
    //按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    // 获得相机胶卷
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    for (PHAssetCollection *collection in smartAlbums){
        if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary){
            //相机胶卷
            [self getPHAsset:collection];
        }
        else if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumScreenshots){
            //屏幕快照
            [self getPHAsset:collection];
        }
        else if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumRecentlyAdded){
            //最近添加
            [self getPHAsset:collection];
        }
        else if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumBursts){
            //连拍快照
            [self getPHAsset:collection];
            
        }
        else if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumPanoramas){
            //全景照片
            [self getPHAsset:collection];
        }
        else if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumSelfPortraits){
            //自拍
            [self getPHAsset:collection];
        }
    }
    
    // 列出所有用户创建的相册
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    for (PHAssetCollection *assetCollection in topLevelUserCollections) {
        NSLog(@"%@", assetCollection.localizedTitle);
        [self getPHAsset:assetCollection];
        
    }
    
}

//获取相册第一张PHAsset对象
-(void)getPHAsset:(PHAssetCollection *)assetCollection{
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    if (assets.count>0){
        [photosNameArr addObject:assetCollection.localizedTitle];
        [photosIdentifiersArr addObject:assetCollection.localIdentifier];
        [self getPhotosList:assets[0]];
    }
}

//获取相册列表
-(void)getPhotosList:(PHAsset *)asset{
    // 在资源的集合中获取第一个集合，并获取其中的图片
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestImageForAsset:asset
                            targetSize:CGSizeMake(500, 500)
                           contentMode:PHImageContentModeDefault
                               options:nil
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             // 得到一张 UIImage，展示到界面上
                             NSLog(@"%@", result);
                             [photosThumbArr addObject:result];
                         }];
}


-(void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%lu", (unsigned long)photosThumbArr.count);
    return photosThumbArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell ==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = photosNameArr[indexPath.row];
    cell.imageView.image = photosThumbArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    WLPhotoViewController *photoVC = [[WLPhotoViewController alloc]init];
    photoVC.photoIdentifier = photosIdentifiersArr[indexPath.row];
    [self.navigationController pushViewController:photoVC animated:YES];
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
