//
//  PhotosFileCollectionViewCell.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/26.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "PhotosFileCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "CommonUrl.h"

@implementation PhotosFileCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setPhotosFileModel:(PhotosFileModel *)photosFileModel{
    _photosFileModel = photosFileModel;
    _albumNameLabel.text = photosFileModel.album_name;
    _createTimeLabel.text = photosFileModel.create_time;
    _photosCountLabel.text = [NSString stringWithFormat:@"%@张",photosFileModel.count];
    [_photoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DOMAINURL,photosFileModel.pic]]];
}

@end
