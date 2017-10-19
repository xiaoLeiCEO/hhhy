//
//  PhotoCollectionViewCell.h
//  hhhy
//
//  Created by 王长磊 on 2017/7/12.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosModel.h"

@interface PhotoCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) PhotosModel *photosModel;

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@end
