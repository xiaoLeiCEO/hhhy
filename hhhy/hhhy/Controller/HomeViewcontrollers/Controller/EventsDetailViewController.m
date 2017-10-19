//
//  EventsDetailViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/17.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "EventsDetailViewController.h"
#import "EventsModel.h"
#import "EventsFooterView.h"
#import "OrderViewController.h"
#import <MapKit/MapKit.h>
#import "PlayerListViewController.h"
#import "VideoListViewController.h"
#import "PhotosFileViewController.h"
@interface EventsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,CLLocationManagerDelegate>{
//    NSMutableArray *dataSource;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) EventsModel *eventsModel;
@property (nonatomic,strong) UIImageView *headerImageView;
@property (nonatomic,strong) EventsFooterView *eventsFooterView;
@property (nonatomic,strong) CLGeocoder *geo;
@property(nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation EventsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    dataSource = [[NSMutableArray alloc]init];
    [self createUI];
    [self loadData];
}

-(void)createUI{
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, screen_width,1)];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    _webView.scrollView.scrollEnabled = NO;
    
    if (_isSaiShi){
        self.navigationItem.title = @"赛事详情";
    }
    else {
        self.navigationItem.title = @"活动详情";
    }
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height-50) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
   _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screen_height, 156)];
    _headerImageView.userInteractionEnabled = YES;
    _tableView.tableHeaderView = _headerImageView;
    [self.view addSubview:_tableView];
    
    _eventsFooterView = [NSBundle.mainBundle loadNibNamed:@"EventsFooterView" owner:self options:nil].lastObject;
    [_eventsFooterView.collectBtn addTarget:self action:@selector(collectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_eventsFooterView.entryBtn addTarget:self action:@selector(entryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _eventsFooterView.entryBtn.tag = 500;
    [_eventsFooterView.audienceEntryBtn addTarget:self action:@selector(entryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _eventsFooterView.audienceEntryBtn.tag = 501;
    _eventsFooterView.frame = CGRectMake(0, screen_height-50, screen_width, 50);
    [self.view addSubview:_eventsFooterView];
}

-(CLGeocoder *)geo
{
    if (!_geo)
    {
        _geo = [[CLGeocoder alloc] init];
        
    }
    return  _geo;
}

//收藏
-(void)collectBtnAction:(UIButton *)sender{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"token"] = [UserInfo getToken];
    parameters[@"hd_id"] = _eventsId;
    
    if (sender.selected){
        parameters[@"act"] = @"del";
    }
    else {
        parameters[@"act"] = @"add";
    }
    [ZMCHttpTool postWithUrl:WLCollectURL parameters:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]){
            //成功
            sender.selected = !sender.selected;
            [self showAlert:responseObject[@"msg"]];
        }
        else {
            //失败
            [self showAlert:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

//报名
-(void)entryBtnAction:(UIButton *)sender{
    OrderViewController *orderVC = [[OrderViewController alloc]init];
    if (_eventsModel.title){
        orderVC.eventsId = _eventsModel.eventsId;
        orderVC.eventsTitle = _eventsModel.title;
        orderVC.isSaiShi = _isSaiShi;
        if (sender.tag==500){
            //点击选手报名
        orderVC.isPlayer = YES;
        }
        else {
            //点击围观报名
            orderVC.isPlayer = NO;
        }
    }
    [self.navigationController pushViewController:orderVC animated:YES];
}

-(void)loadData{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"act"] = @"info";
    parameters[@"hd_id"] = _eventsId;
    parameters[@"token"] = [UserInfo getToken];
    [ZMCHttpTool postWithUrl:WLEventsDetailURL parameters:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]){
                _eventsModel = [[EventsModel alloc]init];
            [_eventsModel setValuesForKeysWithDictionary:responseObject[@"data"][@"info"]];
            if ([[NSString stringWithFormat:@"%@",_eventsModel.is_collection] isEqualToString:@"0"]){
                _eventsFooterView.collectBtn.selected = NO;
            }
            else {
                _eventsFooterView.collectBtn.selected = YES;
            }
            if ([self isAvailable:_eventsModel.close_time]){
                _eventsFooterView.entryBtn.enabled = YES;
                _eventsFooterView.entryBtn.backgroundColor = ThemeColor;
                _eventsFooterView.audienceEntryBtn.enabled = YES;
                _eventsFooterView.audienceEntryBtn.backgroundColor = ThemeColor;
            }
            else {
                _eventsFooterView.entryBtn.enabled = NO;
                _eventsFooterView.entryBtn.backgroundColor = [UIColor lightGrayColor];
                _eventsFooterView.audienceEntryBtn.enabled = NO;
                _eventsFooterView.audienceEntryBtn.backgroundColor = [UIColor lightGrayColor];

            }
            
            NSURL* url = [NSURL URLWithString:_eventsModel.content];//创建URL
            NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
            [_webView loadRequest:request];
            [_tableView reloadData];
        }
        else {
        
        }
    } failure:^(NSError *error) {
        
    }];
}


//开始定位服务
-(void)initializeLocationService {
    
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
        NSLog(@"定位服务可用");
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager startUpdatingLocation];
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        NSLog(@"定位失败，请打开定位服务");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示消息" message:@"定位失败，您没有开启定位服务，请前往设置->隐私，开启定位服务" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *loc=locations.firstObject;
    
    NSLog(@"获取用户位置");
    
    [self.geo reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        //用户当前的位置
        CLPlacemark *beginMark=placemarks.firstObject;
        
        MKPlacemark *mkBeginMark=[[MKPlacemark alloc]initWithPlacemark:beginMark];
        
        MKMapItem *beginItem=[[MKMapItem alloc]initWithPlacemark:mkBeginMark];
        
        [self.geo geocodeAddressString:_eventsModel.address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            CLPlacemark *endMark=placemarks.firstObject;
            
            MKPlacemark *mkEndMark=[[MKPlacemark alloc]initWithPlacemark:endMark];
            
            MKMapItem *endItem=[[MKMapItem alloc]initWithPlacemark:mkEndMark];
            
            
            NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard]};
            
            [MKMapItem openMapsWithItems:@[beginItem,endItem] launchOptions:options];
            [manager stopUpdatingLocation];

        }];
        
    }];
    
}


-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"用户未选择");
            break;
            // 暂时没用，应该是苹果预留接口
        case kCLAuthorizationStatusRestricted:
            NSLog(@"受限制");
            break;
            // 真正被拒绝、定位服务关闭等影响定位服务的行为都会进入被拒绝状态
        case kCLAuthorizationStatusDenied:
            
            if (![CLLocationManager locationServicesEnabled]) { // 定位服务开启
                NSLog(@"真正被用户拒绝");
                //  跳转到设置界面
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                
                if ([[UIApplication sharedApplication] canOpenURL:url]) {   // url地址可以打开
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            } else {
                NSLog(@"服务未开启");
            }
            
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"前后台定位授权");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"前台定位授权");
            break;
            
        default:
            break;
    }
}


//判断当前时间与所给时间是否过期
-(BOOL)isAvailable:(NSString *)timeStr{

    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate *closeTimeDate = [formatter dateFromString:timeStr];
    
    NSDate *laterDate = [nowDate laterDate:closeTimeDate];
    
    if ([laterDate isEqualToDate:closeTimeDate]){
        //可以报名
        return YES;
    }
    else {
        //已经过期
        return NO;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell1 = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell1){
        cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    }
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_eventsModel){
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DOMAINURL,_eventsModel.poster]] placeholderImage:[UIImage imageNamed:@"dynamicImage"]];
    if (indexPath.row == 0){
        cell1.textLabel.numberOfLines = 0;
        cell1.textLabel.text = _eventsModel.title;
    }
    else if (indexPath.row == 1){
        cell1.textLabel.text = [NSString stringWithFormat:@"%@ 至 %@",_eventsModel.starttime,_eventsModel.close_time];
        cell1.imageView.image = [UIImage imageNamed:@"shiKeBiao"];
    }
    else if (indexPath.row == 2){
        cell1.textLabel.text = _eventsModel.address;
        cell1.imageView.image = [UIImage imageNamed:@"weiZhi"];
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    else if (indexPath.row == 3){
        cell1.textLabel.text = [NSString stringWithFormat:@"报名人数: %@/%@",_eventsModel.sign_counts,_eventsModel.limit_num];
        cell1.imageView.image = [UIImage imageNamed:@"grzx"];
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    else if (indexPath.row == 4){
        cell1.textLabel.text = @"参赛视频";
        cell1.imageView.image = [UIImage imageNamed:@"video"];
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    else if (indexPath.row == 5){
        cell1.textLabel.text = @"参赛图集";
        cell1.imageView.image = [UIImage imageNamed:@"video"];
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    else {
        UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (cell2==nil){
            cell2 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
            [cell2.contentView addSubview:_webView];
        }
        return cell2;
    }
    }

    return cell1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示消息" message:@"打开手机地图" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self initializeLocationService];
        }];
        [alert addAction:sure];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else if (indexPath.row ==3){
        //跳转报名选手列表
        PlayerListViewController *playerListVC = [[PlayerListViewController alloc]init];
        playerListVC.eventsId = _eventsId;
        [self.navigationController pushViewController:playerListVC animated:YES];
    }
    else if (indexPath.row == 4){
        //跳转视频列表
        VideoListViewController *videoListVC = [[VideoListViewController alloc]init];
        videoListVC.eventsId = _eventsId;
        videoListVC.isSaiShi = self.isSaiShi;
        [self.navigationController pushViewController:videoListVC animated:YES];
    }
    else if (indexPath.row == 5){
        PhotosFileViewController *photoFileVC = [[PhotosFileViewController alloc]init];
        photoFileVC.isEvents = YES;
        photoFileVC.eventsId = _eventsId;
        [self.navigationController pushViewController:photoFileVC animated:YES];
        
    }
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{

    _webView.frame = CGRectMake(0, 0, screen_width,[[_webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue]);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)updateCellHeight{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==6){
        return [[_webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    }
    else {
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
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
