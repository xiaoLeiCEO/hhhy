//
//  UploadPictureViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/8/21.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "UploadPictureViewController.h"
#import "WLPhotoViewController.h"
#import "WLPhotoFileViewController.h"
#import "UploadImg.h"
#import "AnnouncePhotoCollectionViewCell.h"
@interface UploadPictureViewController ()<UITextViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation UploadPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    [self createUI];
    
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


//上传
-(void)rightBtnAction{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"act"] = @"upload_album_pic";
    parameters[@"album_id"] = _albumId;
    parameters[@"title"] = _writeTf.text;
    parameters[@"token"] = [UserInfo getToken];
    parameters[@"method"] = @"more";
    
    NSMutableArray *imageData = [[NSMutableArray alloc]init];
    [self showProgressHud:MBProgressHUDModeIndeterminate message:@"正在上传..."];
    if (_imageArr.count >0) {
                for (UIImage *selectPhtoto in _imageArr){
                    
                    [imageData addObject:[UploadImg compressImage:selectPhtoto toByte:5000000]];
                    
                }
                [UploadImg uploadImage:imageData withUrl:WLMinePhotosURL withParameters:parameters withImageName:@"pic[]" successBlock:^(id responseObject) {
                    NSLog(@"%@", responseObject);
                    if ([responseObject[@"status"] isEqualToString:@"1"]){
                        [self hideProgressHud];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else {
                        [self showAlert:responseObject[@"msg"]];
                    }
                }];
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_writeTf resignFirstResponder];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _imageArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AnnouncePhotoCollectionViewCell *announcePhotoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"announcePhotoCell" forIndexPath:indexPath];
        announcePhotoCell.photoImageView.image = _imageArr[indexPath.row];
    return announcePhotoCell;
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
