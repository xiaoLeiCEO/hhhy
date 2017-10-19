//
//  MessageViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/1.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "MessageViewController.h"
#import "MenuCollectionViewCell.h"
#import "MessageCollectionViewCell.h"
#import "MessageDetailForH5ViewController.h"

@interface MessageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MessageCollectionViewCellDelegate>{
//    NSArray *menuArr;
}
//@property (nonatomic,strong) UICollectionView *menuView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"资讯";
    [self createUI];
}

-(void)createUI{
//    menuArr = @[@"自媒体",@"媒体资讯",@"百家言论",@"财经",@"娱乐",@"体育"];
//
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    flowLayout.minimumInteritemSpacing = 20;
//    
//    _menuView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, screen_width, 44) collectionViewLayout:flowLayout];
//    _menuView.tag = 100;
//    _menuView.showsVerticalScrollIndicator = NO;
//    _menuView.showsHorizontalScrollIndicator = NO;
//    _menuView.delegate = self;
//    _menuView.dataSource = self;
    
//    UINib *cellNib=[UINib nibWithNibName:@"MenuCollectionViewCell" bundle:nil];
//    [_menuView registerNib:cellNib forCellWithReuseIdentifier:@"menu"];
//    
//    _lineView = [[UIView alloc]init];
//    _lineView.backgroundColor = [UIColor redColor];
//    [_menuView addSubview:_lineView];
//    [self.view addSubview:_menuView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, screen_width, screen_height - 64) collectionViewLayout:layout];
    _collectionView.tag = 200;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    UINib *nib = [UINib nibWithNibName:@"MessageCollectionViewCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"messageCell"];
    [self.view addSubview:_collectionView];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (collectionView.tag == 100){
        return 1;
    }
    else {
    
        return 1;
    }
}


//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    if (scrollView.tag == 200){
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_collectionView.contentOffset.x / screen_width inSection:0];
//        MenuCollectionViewCell *menuCell = (MenuCollectionViewCell *)[_menuView cellForItemAtIndexPath:indexPath];
//        [UIView animateWithDuration:0.5 animations:^{
//            _lineView.frame =  CGRectMake(menuCell.frame.origin.x, 42, menuCell.frame.size.width, 2);
//        }];
//        [_menuView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
//    }
//}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
//    return menuArr.count;
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//
//    if (collectionView.tag == 100){
//        MenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menu" forIndexPath:indexPath];
//        cell.menuLabel.text = menuArr[indexPath.row];
//        return cell;
//    }
//    else {
//        MessageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"messageCell" forIndexPath:indexPath];
//        return cell;
//    }
    MessageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"messageCell" forIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (collectionView.tag == 100){
        MenuCollectionViewCell *menuCell = (MenuCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [UIView animateWithDuration:0.5 animations:^{
            _lineView.frame =  CGRectMake(menuCell.frame.origin.x, 42, menuCell.frame.size.width, 2);
        }];
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
        [_collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}


-(BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (collectionView.tag == 100){
//        for (int i=0;i<menuArr.count;i++){
//            CGSize size=[menuArr[i] boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
//            if (indexPath.row == i) {
//                NSLog(@"%f",size.width);
//                return CGSizeMake(size.width, 44);
//            }
//            if (i==0){
//                _lineView.frame = CGRectMake(0, 42, size.width, 2);
//            }
//        }
    }
    else {
        return CGSizeMake(screen_width, screen_height - 64);
    }
    return CGSizeMake(0, 0);

}

-(void)pushMessageDetailViewController:(NSString *)urlString withUserId:(NSString *)userId{
    MessageDetailForH5ViewController *messageDetailVC = [[MessageDetailForH5ViewController alloc]init];
    messageDetailVC.content = urlString;
    messageDetailVC.userId = userId;
    [self.navigationController pushViewController:messageDetailVC animated:YES];
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
