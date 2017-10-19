//
//  WLPreviewPhotoViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/28.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "WLPreviewPhotoViewController.h"
#import "PreviewPhotoCollectionViewCell.h"
#import <Photos/Photos.h>
#import "UIImageView+WebCache.h"
@interface WLPreviewPhotoViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation WLPreviewPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.collectionView];
    [self.collectionView scrollToItemAtIndexPath:_indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) collectionViewLayout:flowLayout];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PreviewPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"previewCell"];
    }
    return _collectionView;
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _previewPhotosArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PreviewPhotoCollectionViewCell *cell = (PreviewPhotoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"previewCell" forIndexPath:indexPath];
    if ([_previewPhotosArr.lastObject isKindOfClass:[UIImage class]]){
        cell.imageView.image = _previewPhotosArr[indexPath.row];
    }
    else {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DOMAINURL,_previewPhotosArr[indexPath.row]]]];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(screen_width, screen_height);
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
