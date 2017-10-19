//
//  VideoListTableViewCell.m
//  textttt
//
//  Created by 王长磊 on 2017/8/1.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "VideoListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CommonUrl.h"
@implementation VideoListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_progressSlider setThumbImage:[UIImage imageNamed:@"sliderThumb"] forState:normal];

}

-(void)setVideoListModel:(VideoListModel *)videoListModel{
    _videoListModel = videoListModel;
    [_videoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DOMAINURL,videoListModel.image]] placeholderImage:[UIImage imageNamed:@"paishe"]];
    _titleLabel.text = videoListModel.title;
    _desLabel.text = videoListModel.descri;
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    [options setPlayerOptionIntValue:5      forKey:@"framedrop"];
    _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DOMAINURL,_videoListModel.content]] withOptions:options];
    _player.shouldAutoplay = NO;
    [_player prepareToPlay];
    [self.videoImageView addSubview:_player.view];
    
    [self hideControlView];

}
- (IBAction)progressSliderAction:(UISlider *)sender {
    self.player.currentPlaybackTime = sender.value;
}

-(void)prepareForReuse{
    [super prepareForReuse];
    if (_player.view){
        if ([_player isPlaying]){
            [_player shutdown];
        }
    }
    [_player.view removeFromSuperview];
}

//这时约束起作用了
-(void)layoutIfNeeded{
    [super layoutIfNeeded];
    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
    _player.view.frame = CGRectMake(0, 0, self.videoImageView.frame.size.width, self.videoImageView.frame.size.height);
    NSLog(@"%f",_player.view.frame.size.width);

}

//这时候约束还没起作用
//-(void)layoutSubviews{
//    [super layoutSubviews];
//    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
//    _player.view.frame = CGRectMake(0, 0, self.videoImageView.frame.size.width, self.videoImageView.frame.size.height);    
//    NSLog(@"%f",_player.view.frame.size.width);
//    
//}

- (IBAction)playAndPauseBtn:(UIButton *)sender {
    if ([_player isPlaying]){
        [_player pause];
        [sender setTitle:@"播放" forState:normal];
    }
    else {
        [_player play];
        [sender setTitle:@"暂停" forState:normal];
    }
}

//显示控制器
-(void)showControlView {
    _controlView.hidden = NO;
    [self refreshMediaControl];
    [self cancelDelayedHide];
    [self performSelector:@selector(hideControlView) withObject:nil afterDelay:5];

}
//隐藏控制器
-(void)hideControlView{
    _controlView.hidden = YES;
    [self cancelDelayedHide];

}

- (void)cancelDelayedHide
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControlView) object:nil];
}


- (void)refreshMediaControl
{
    // duration
    NSTimeInterval duration = self.player.duration;
    NSInteger intDuration = duration + 0.5;
    self.progressSlider.maximumValue = duration;

//    if (intDuration > 0) {
//        self.progressSlider.maximumValue = duration;
//        self.progressLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)(intDuration / 60), (int)(intDuration % 60)];
//    } else {
//        self.progressLabel.text = @"--:--";
//        self.progressSlider.maximumValue = 1.0f;
//    }
    
    
    // position
    NSTimeInterval position;

    position = self.player.currentPlaybackTime;
    
    NSInteger intPosition = position + 0.5;
    if (intDuration > 0) {
        self.progressSlider.value = position;
    } else {
        self.progressSlider.value = 0.0f;
    }
    self.progressLabel.text = [NSString stringWithFormat:@"%02d:%02d/%02d:%02d", (int)(intPosition / 60), (int)(intPosition % 60),(int)(intDuration / 60), (int)(intDuration % 60)];
    
    
    if ([_player isPlaying]){
        [_playAndPauseBtn setTitle:@"暂停" forState:normal];
    }
    else {
        [_playAndPauseBtn setTitle:@"播放" forState:normal];
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
    if (!self.controlView.hidden) {
        [self performSelector:@selector(refreshMediaControl) withObject:nil afterDelay:0.5];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
