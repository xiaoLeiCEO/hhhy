//
//  PhotosFileCollectionViewCell.h
//  hhhy
//
//  Created by 王长磊 on 2017/7/26.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosFileModel.h"

@interface PhotosFileCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) PhotosFileModel *photosFileModel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (weak, nonatomic) IBOutlet UILabel *albumNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *photosCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;

@end
