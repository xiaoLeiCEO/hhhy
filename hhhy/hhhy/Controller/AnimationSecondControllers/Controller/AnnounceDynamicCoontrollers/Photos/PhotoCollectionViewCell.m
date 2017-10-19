//
//  PhotoCollectionViewCell.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/12.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "CommonUrl.h"


@implementation PhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



-(void)setPhotosModel:(PhotosModel *)photosModel{
    _photosModel = photosModel;
    [_selectBtn removeFromSuperview];
    [_photoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DOMAINURL,photosModel.path]]];
}

@end
