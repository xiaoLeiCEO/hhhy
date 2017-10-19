//
//  VideoPlayViewController.m
//  hhhy
//
//  Created by 王长磊 on 2017/8/11.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "VideoPlayViewController.h"
#import <Photos/Photos.h>
#import "UploadImg.h"

@interface VideoPlayViewController ()
{
    BOOL isDidEndPlay;
}


@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) PHFetchResult *fetchResult;
@end

@implementation VideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isDidEndPlay = NO;
    self.view.backgroundColor = [UIColor blackColor];
    
    UIBarButtonItem *sureBtn = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureBtnAction:)];
    self.navigationItem.rightBarButtonItem = sureBtn;

    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    _fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:options];
    PHVideoRequestOptions *options2 = [[PHVideoRequestOptions alloc] init];
    options2.deliveryMode=PHVideoRequestOptionsDeliveryModeAutomatic;
    
    [[PHImageManager defaultManager] requestPlayerItemForVideo:_fetchResult[_index] options:options2 resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.player = [[AVPlayer alloc]initWithPlayerItem:playerItem];
            AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
            playerLayer.frame = CGRectMake(0, 0, screen_width, screen_height);
            [self.view.layer addSublayer:playerLayer];
             [self createUI];
        });
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
     
                                            selector:@selector(moviePlayDidEnd:)
     
                                                name:AVPlayerItemDidPlayToEndTimeNotification
     
                                              object:self.player.currentItem];
    
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}


//确定按钮
-(void)sureBtnAction:(UIBarButtonItem *)sender{
    sender.enabled = NO;
    
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc]init];
    imageRequestOptions.version = PHImageRequestOptionsVersionOriginal;
    imageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    imageRequestOptions.synchronous = YES;
        //获取视频的第一帧图
        [self showProgressHud:MBProgressHUDModeIndeterminate message:@"正在处理"];
        [[PHImageManager defaultManager] requestImageForAsset:_fetchResult[_index] targetSize:CGSizeMake((screen_width-3*5)/4*scale_screen, (screen_width-3*5)/4*scale_screen) contentMode:PHImageContentModeAspectFit options:imageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result){
                [UploadImg compressedVideo:self.player.currentItem.asset success:^(BOOL isSuccess) {
                    if (isSuccess){
                        CMTime durationV = self.player.currentItem.duration;
                        NSUInteger dTotalSeconds = CMTimeGetSeconds(durationV);
                        NSUInteger dHours = floor(dTotalSeconds / 3600);
                        NSUInteger dMinutes = floor(dTotalSeconds % 3600 / 60);
                        NSUInteger dSeconds = floor(dTotalSeconds % 3600 % 60);
                        NSString *videoDurationText = [NSString stringWithFormat:@"%lu:%02lu:%02lu",(unsigned long)dHours, (unsigned long)dMinutes, (unsigned long)dSeconds];
                        NSDictionary *dic = @{@"image":result,@"duration":videoDurationText};
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectVideo" object:nil userInfo:dic];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self hideProgressHud];
                            [self dismissViewControllerAnimated:YES completion:nil];

                        });
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self showProgressHud:MBProgressHUDModeIndeterminate message:@"压缩失败"];
                            [self hideProgeressHudAfterDelay:2];
                        });
                    }
                }];
                
            }
        }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UploadImg cancelCompressVideo];
    [self.navigationController.navigationBar setHidden:NO];
}


-(void)moviePlayDidEnd:(NSNotification *)notification{
    isDidEndPlay = YES;
    UIButton *playAndPauseBtn = [self.view viewWithTag:100];
    [playAndPauseBtn setImage:[UIImage imageNamed:@"bofang"] forState:normal];
    [self.navigationController.navigationBar setHidden:NO];

}


-(void)createUI{
    UIButton *playAndPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playAndPauseBtn.frame = CGRectMake(0, 0, screen_width, screen_height);
    [playAndPauseBtn setImage:[UIImage imageNamed:@"bofang"] forState:normal];
    [self.navigationController.navigationBar setHidden:NO];

    playAndPauseBtn.tag = 100;
    [playAndPauseBtn addTarget:self action:@selector(playAndPauseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playAndPauseBtn];
}


-(void)playAndPauseBtnAction:(UIButton *)sender{
    if (self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying){
        [sender setImage:[UIImage imageNamed:@"bofang"] forState:normal];
        [self.navigationController.navigationBar setHidden:NO];

            [self.player pause];
    }
    else {
        if (isDidEndPlay){
            [self.player seekToTime:kCMTimeZero];
            isDidEndPlay = NO;
        }
        [sender setImage:nil forState:normal];
        [self.navigationController.navigationBar setHidden:YES];
        [self.player play];

    }
}



-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
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
