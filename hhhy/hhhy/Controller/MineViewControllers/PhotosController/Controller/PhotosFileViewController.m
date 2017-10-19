//
//  PhotosFileViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/20.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "PhotosFileViewController.h"
#import "PhotosViewController.h"
#import "PhotosFileCollectionViewCell.h"
#import "AddPhotosViewController.h"
@interface PhotosFileViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSMutableArray *photosArr;
    int page;
}
@property (nonatomic,strong) UICollectionView *photoCollectionView;

@end

@implementation PhotosFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    page = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"相册";
    photosArr = [[NSMutableArray alloc]init];
    [self createUI];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self loadData];
}

-(void)createUI{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    _photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) collectionViewLayout:flowLayout];
    _photoCollectionView.backgroundColor = [UIColor whiteColor];
    _photoCollectionView.delegate = self;
    _photoCollectionView.dataSource = self;
    [_photoCollectionView registerNib:[UINib nibWithNibName:@"PhotosFileCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"photosFileCell"];
    [self.view addSubview:_photoCollectionView];
}

-(void)loadData{
    
    [photosArr removeAllObjects];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    if (_isEvents){
        parameters[@"act"] = @"activity_album_list";
        parameters[@"token"] = [UserInfo getToken];
        parameters[@"page"] = [NSString stringWithFormat:@"%d",page];
        parameters[@"pagesize"] = @"50";
        parameters[@"hd_id"] = _eventsId;
        parameters[@"type"] = @"2";
        
    }
    else {
        parameters[@"act"] = @"u_album_list";
        parameters[@"token"] = [UserInfo getToken];
        parameters[@"page"] = [NSString stringWithFormat:@"%d",page];
        parameters[@"pagesize"] = @"50";
    }

    
    [ZMCHttpTool postWithUrl:WLMinePhotosURL parameters:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]){
            for (NSDictionary *dic in responseObject[@"data"][@"list"]){
                PhotosFileModel *photosFileModel = [[PhotosFileModel alloc]init];
                [photosFileModel setValuesForKeysWithDictionary:dic];
                [photosArr addObject:photosFileModel];
            }
            [_photoCollectionView reloadData];
        }
        else {
            
        }
    } failure:^(NSError *error) {
        
    }];
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return photosArr.count+1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotosFileCollectionViewCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photosFileCell" forIndexPath:indexPath];
    if (indexPath.row==0){
        photoCell.photoImageView.image = [UIImage imageNamed:@"addPhotos"];
        photoCell.albumNameLabel.text = @"";
        photoCell.photosCountLabel.text = @"";
        photoCell.createTimeLabel.text = @"";
    }
    else {
    photoCell.photosFileModel = photosArr[indexPath.row-1];
    }
    return photoCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((screen_width-3*10)/2, (screen_width-3*10)/2+44);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0){
        //新建相册
        AddPhotosViewController *addPhotosVC = [[AddPhotosViewController alloc]init];
        addPhotosVC.isEvents = _isEvents;
        addPhotosVC.eventsId = _eventsId;
        UINavigationController *addPhotosNav = [[UINavigationController alloc]initWithRootViewController:addPhotosVC];
        [self presentViewController:addPhotosNav animated:YES completion:nil];
    }
    else {
        PhotosViewController *photosVC = [[PhotosViewController alloc]init];
        PhotosFileModel *photosFileModel = photosArr[indexPath.row-1];
        photosVC.albumId = photosFileModel.album_id;
        [self.navigationController pushViewController:photosVC animated:YES];
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
