//
//  VideoListViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/8/2.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "VideoListViewController.h"
#import "VideoListTableViewCell.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "UpLoadVideoViewController.h"

@interface VideoListViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSMutableArray *dataSource;
    int page;
}
@property (nonatomic,strong) UITableView *tableView;
@property (atomic, retain) id <IJKMediaPlayback> player;
@property(nonatomic,strong) UIActivityIndicatorView *loadingView;

@end

@implementation VideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"视频";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    self.view.backgroundColor = [UIColor whiteColor];
    dataSource = [[NSMutableArray alloc]init];
    page = 1;
    [self createUI];
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addNotifaction];
}

//上传视频按钮点击事件
-(void)rightBtnAction:(UIBarButtonItem *)sender{
    
        //判断用户是否报名
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    parameter[@"act"] = @"is_cansai";
    if (_isSaiShi){
        parameter[@"mark"] = @"1";
    }
    else {
        parameter[@"mark"] = @"0";
    }
    parameter[@"hd_id"] = self.eventsId;
    parameter[@"token"] = [UserInfo getToken];
    
    [ZMCHttpTool postWithUrl:WLIsParticipateURL parameters:parameter
                     success:^(id responseObject) {
                         NSLog(@"%@", responseObject);
                         if ([responseObject[@"status"] isEqualToString:@"1"]){
                             UpLoadVideoViewController *uploadVideoVC = [[UpLoadVideoViewController alloc]init];
                             uploadVideoVC.eventsId = self.eventsId;
                             UINavigationController *uploadVideoNav = [[UINavigationController alloc]initWithRootViewController:uploadVideoVC];
                             [self presentViewController:uploadVideoNav animated:YES completion:nil];
                         }
                         else{
                             [self showAlert:responseObject[@"msg"]];
                         }
                     } failure:^(NSError *error) {
                         
                     }];



}


-(void)addNotifaction
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
}

-(UIActivityIndicatorView *)loadingView{
    if (!_loadingView){
        _loadingView = [[UIActivityIndicatorView alloc]init];
        _loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    }
    return _loadingView;
}


-(void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"VideoListTableViewCell" bundle:nil] forCellReuseIdentifier:@"videoCell"];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [dataSource removeAllObjects];
        [self loadData];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page += 1;
        [self loadData];
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

-(void)loadData{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"token"] = [UserInfo getToken];
    parameters[@"hd_id"] = _eventsId;
    parameters[@"page"] = [NSString stringWithFormat:@"%d",page];
    [ZMCHttpTool postWithUrl:WLEventsDetailVideoURL parameters:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]){
            for (NSDictionary *dic in responseObject[@"data"]){
                VideoListModel *videoListModel = [[VideoListModel alloc]init];
                [videoListModel setValuesForKeysWithDictionary:dic];
                [dataSource addObject:videoListModel];
            }
            [_tableView.mj_footer endRefreshing];
            [_tableView.mj_header endRefreshing];
            [_tableView reloadData];
        }
        else {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
            [_tableView.mj_header endRefreshing];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoListTableViewCell *videoCell = [tableView dequeueReusableCellWithIdentifier:@"videoCell" forIndexPath:indexPath];
    videoCell.videoListModel = dataSource[indexPath.row];
    videoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return videoCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoListTableViewCell *videoCell = [tableView cellForRowAtIndexPath:indexPath];
    self.loadingView.frame = CGRectMake(0, 0, 30, 30);
    self.loadingView.center = videoCell.player.view.center;
    [videoCell.player.view addSubview:self.loadingView];
    [self.loadingView startAnimating];
    videoCell.player.view.backgroundColor = [UIColor blackColor];
    
    if (_player && (_player != videoCell.player)){

        NSLog(@"%lu", (unsigned long)_player.loadState);
        
        [_player pause];
    }
    
    self.player = videoCell.player;
    
    if (![videoCell.player isPlaying]){
//        [videoCell.player prepareToPlay];
        [videoCell.player play];
        [videoCell hideControlView];
    }
    else {
        [self.loadingView stopAnimating];
        [videoCell showControlView];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (screen_height-64)/2;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    VideoListTableViewCell *videoListCell = [_tableView cellForRowAtIndexPath:[_tableView indexPathForSelectedRow]];
    //往下滑；
    if (scrollView.contentOffset.y + 64 < videoListCell.frame.origin.y + (screen_height-64)/2 - 100){
        //播放的cell还没有消失
    }
    else {
        //已经消失
//        NSLog(@"第%ld行 标题为%@ 已经消失",[_tableView indexPathForSelectedRow].row,videoListCell.titleLabel.text);
        [self.player pause];
            
    }
}

- (void)loadStateDidChange:(NSNotification*)notification
{
    
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        [self.loadingView stopAnimating];
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        [self.loadingView startAnimating];
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}


- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    //    MPMoviePlaybackStateStopped,
    //    MPMoviePlaybackStatePlaying,
    //    MPMoviePlaybackStatePaused,
    //    MPMoviePlaybackStateInterrupted,
    //    MPMoviePlaybackStateSeekingForward,
    //    MPMoviePlaybackStateSeekingBackward
    
    switch (_player.playbackState)
    {
        case IJKMPMoviePlaybackStateStopped: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            [self.loadingView stopAnimating];
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            [self.loadingView startAnimating];
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
}

-(void)dealloc{
    [self removeMovieNotificationObservers];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.player shutdown];
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
