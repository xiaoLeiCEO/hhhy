//
//  VideoListTableViewCell.h
//  textttt
//
//  Created by 王长磊 on 2017/8/1.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "VideoListModel.h"
@interface VideoListTableViewCell : UITableViewCell

@property (nonatomic,strong) VideoListModel *videoListModel;

@property (atomic, retain) id <IJKMediaPlayback> player;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property (weak, nonatomic) IBOutlet UIView *controlView;
@property (weak, nonatomic) IBOutlet UIButton *playAndPauseBtn;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;


- (void)refreshMediaControl;
//显示控制器
-(void)showControlView;
//隐藏控制器
-(void)hideControlView;
@end
